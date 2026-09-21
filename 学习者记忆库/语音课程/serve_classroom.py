"""Serve the unified classroom and persist learner answers locally."""

from __future__ import annotations

import argparse
import json
import os
import tempfile
from datetime import datetime
from http.server import SimpleHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path
from urllib.parse import parse_qs, urlparse


class ClassroomHandler(SimpleHTTPRequestHandler):
    classroom_root: Path
    memory_root: Path
    _contract_cache: list[dict] | None = None
    _course_cache: list[dict] | None = None
    _contract_by_id: dict[str, dict] | None = None
    _summary_cache: dict[str, dict] = {}
    _pronunciation_cache: dict | None = None
    _vocabulary_plan_cache: dict | None = None
    _grammar_plan_cache: dict | None = None

    ENGLISH_ROADMAP = [
        {
            "id": "A0", "label": "完全零基础", "course_start": 1, "course_end": 40,
            "word_target": 400, "grammar_scope": "字母与大小写、键盘与空格、音形/词边界、I/you、be、a/an、this/that、单复数、最短问答和基本标点",
            "skills": ["认读高频词", "键盘拼写和听写", "听懂极短课堂指令", "写出三词句"],
            "writing_task": "用 3–5 个词写出一个电脑动作。",
            "reading_task": "逐词朗读本课英文句，再指出主语、动词和宾语。",
            "capstone": "在平台内读懂、听写并键入一段 50 词以内的计算机说明。",
        },
        {
            "id": "A1", "label": "基础交流与技术词", "course_start": 41, "course_end": 100,
            "word_target": 1360, "grammar_scope": "一般现在时、第三人称单数、冠词、复数、疑问句、介词",
            "skills": ["掌握常用计算机动词", "写正确主动句", "读懂短教程", "回答事实问题"],
            "writing_task": "写 3–5 句，说明一个程序如何接收输入并产生输出。",
            "reading_task": "从短技术段落中找出动作、对象和条件。",
            "capstone": "完成一页双语工具使用说明。",
        },
        {
            "id": "A2", "label": "连贯技术表达", "course_start": 101, "course_end": 180,
            "word_target": 3360, "grammar_scope": "过去/将来、情态动词、比较级、从句、连接词、被动语态入门",
            "skills": ["写连贯段落", "描述实验步骤", "解释错误和修复", "复述因果关系"],
            "writing_task": "写 80–120 词实验记录，包含现象、原因和下一步。",
            "reading_task": "标出技术文章中的时间顺序、因果和转折。",
            "capstone": "独立完成一份带图表说明的实验报告。",
        },
        {
            "id": "B1", "label": "工程沟通", "course_start": 181, "course_end": 290,
            "word_target": 7100, "grammar_scope": "复杂句、条件句、被动语态、关系从句、段落主题句和衔接",
            "skills": ["读 API 和设计文档", "写故障报告", "比较两种方案", "进行 5 分钟技术口述"],
            "writing_task": "写 180–250 词技术决策记录，说明取舍和证据。",
            "reading_task": "概括文档每段的主张、依据和限制。",
            "capstone": "提交一份工程 RFC 或 ADR，并接受追问。",
        },
        {
            "id": "B2", "label": "学术技术英语", "course_start": 291, "course_end": 410,
            "word_target": 11900, "grammar_scope": "名词化、复杂被动、条件推理、让步、定义句、篇章衔接和语域",
            "skills": ["精读论文结构", "综合多个来源", "写方法和结果", "准确表达不确定性"],
            "writing_task": "写 300–500 词 mini literature review，包含引用和局限。",
            "reading_task": "区分论文中的 claim、evidence、assumption 和 limitation。",
            "capstone": "完成一篇结构完整的技术综述初稿。",
        },
        {
            "id": "C1", "label": "研究与批判表达", "course_start": 411, "course_end": 500,
            "word_target": 15950, "grammar_scope": "学术语域、hedging、名词短语、平行结构、复杂论证和引用规范",
            "skills": ["批判性精读", "复现并审查研究", "写清楚方法边界", "进行学术答辩"],
            "writing_task": "写 600–900 词研究问题与方法草案，明确变量和威胁。",
            "reading_task": "对一篇论文做论证地图并指出可证伪处。",
            "capstone": "完成可复现研究报告和英文口头答辩。",
        },
        {
            "id": "C2", "label": "出版级表达", "course_start": 501, "course_end": 560,
            "word_target": 18830, "grammar_scope": "出版级句法、精确措辞、修辞结构、同行评审语气和跨段论证",
            "skills": ["编辑复杂论文", "回应审稿意见", "写摘要和 cover letter", "跨领域解释"],
            "writing_task": "写 1000–1500 词论文节选，并完成两轮自我编辑。",
            "reading_task": "比较不同论文对同一结论的措辞强度和证据质量。",
            "capstone": "完成一篇可送同行评审的英文技术论文。",
        },
        {
            "id": "C2+", "label": "计算机学术宗师", "course_start": 561, "course_end": 590,
            "word_target": 20000, "grammar_scope": "跨学科研究写作、理论论证、审稿、教学和学术共同体沟通",
            "skills": ["提出原创问题", "构建严谨论证", "指导他人研究", "在英文环境中持续产出"],
            "writing_task": "写一篇完整研究论文，并给出数据、代码、局限和复现说明。",
            "reading_task": "批判性复现论文并写出可被反驳的审稿意见。",
            "capstone": "完成英文论文、开源复现包、答辩和教学演示。",
        },
    ]

    def course_id_from_query(self, parsed) -> str:
        value = parse_qs(parsed.query).get("course_id", ["PRE0"])[0]
        return value if value.replace("-", "").isalnum() else "PRE0"

    @staticmethod
    def int_query(parsed, name: str, default: int) -> int:
        try:
            return int(parse_qs(parsed.query).get(name, [str(default)])[0] or default)
        except (TypeError, ValueError):
            return default

    @staticmethod
    def safe_course_id(value: object) -> str:
        candidate = str(value or "PRE0")
        return candidate if candidate.replace("-", "").isalnum() else "PRE0"

    def load_courses(self) -> list[dict]:
        if self._course_cache is not None:
            return self._course_cache
        matrix_path = self.memory_root / "掌握矩阵.json"
        try:
            matrix = json.loads(matrix_path.read_text(encoding="utf-8"))
            self._course_cache = matrix if isinstance(matrix, list) else matrix.get("courses", [])
            return self._course_cache
        except (OSError, json.JSONDecodeError):
            return []

    def course_record(self, course_id: str) -> dict:
        return next((item for item in self.load_courses() if item.get("id") == course_id), {"id": course_id, "title": course_id, "topic_focus": "computer science"})

    def course_navigation(self, course_id: str) -> dict:
        """Return stable previous/next course links without changing learner state."""
        courses = self.load_courses()
        index = next((i for i, item in enumerate(courses) if str(item.get("id")) == course_id), -1)
        if index < 0:
            return {"course_id": course_id, "course_index": 0, "total_courses": len(courses) or 590, "previous": None, "next": None}

        def link(position: int) -> dict:
            item = courses[position]
            return {"id": item.get("id"), "title": item.get("title", item.get("id")), "index": position + 1}

        return {
            "course_id": course_id,
            "course_index": index + 1,
            "total_courses": len(courses) or 590,
            "previous": link(index - 1) if index > 0 else None,
            "next": link(index + 1) if index + 1 < len(courses) else None,
        }

    def load_video_config(self) -> dict:
        """Read optional local video resources; an invalid config never breaks a lesson."""
        config_path = self.classroom_root / "视频课件配置.json"
        payload = self.load_json_file(config_path, {"enabled": False, "items": [], "default_items": []})
        return payload if isinstance(payload, dict) else {"enabled": False, "items": [], "default_items": []}

    @staticmethod
    def clean_video_item(item: object) -> dict | None:
        if not isinstance(item, dict):
            return None
        title = str(item.get("title", "")).strip()[:200]
        if not title:
            return None
        def text(name: str, limit: int = 500) -> str:
            return str(item.get(name, "")).strip()[:limit]
        return {
            "id": text("id", 120),
            "title": title,
            "provider": text("provider", 120),
            "kind": text("kind", 80) or "video",
            "description": text("description", 800),
            "duration": text("duration", 40),
            "captions": text("captions", 200),
            "watch_url": text("watch_url", 1000),
            "embed_url": text("embed_url", 1000),
            "local_path": text("local_path", 500).replace("\\", "/"),
        }

    def video_resources(self, course_id: str) -> dict:
        config = self.load_video_config()
        course = self.course_record(course_id)
        category = str(course.get("category", ""))
        selected: list[dict] = []
        seen: set[str] = set()
        defaults = config.get("default_items", [])
        configured = config.get("items", [])
        defaults = defaults if isinstance(defaults, list) else []
        configured = configured if isinstance(configured, list) else []
        for raw, is_default in [(item, True) for item in defaults] + [(item, False) for item in configured]:
            item = self.clean_video_item(raw)
            if not item:
                continue
            ids = {str(value) for value in raw.get("course_ids", [])} if isinstance(raw, dict) else set()
            prefixes = [str(value) for value in raw.get("course_prefixes", [])] if isinstance(raw, dict) else []
            categories = {str(value) for value in raw.get("categories", [])} if isinstance(raw, dict) else set()
            matches = is_default or course_id in ids or any(course_id.startswith(prefix) for prefix in prefixes) or category in categories
            if not matches:
                continue
            key = item["id"] or item["title"]
            if key in seen:
                continue
            seen.add(key)
            selected.append(item)
        return {"enabled": bool(config.get("enabled", False)), "course_id": course_id, "items": selected[:12], "config_path": "视频课件配置.json"}

    def load_json_file(self, path: Path, default):
        try:
            return json.loads(path.read_text(encoding="utf-8"))
        except (OSError, json.JSONDecodeError):
            return default

    def save_json_file(self, path: Path, payload) -> None:
        path.parent.mkdir(parents=True, exist_ok=True)
        data = json.dumps(payload, ensure_ascii=False, indent=2) + "\n"
        temp_path: Path | None = None
        try:
            with tempfile.NamedTemporaryFile(
                mode="w", encoding="utf-8", newline="\n", dir=path.parent,
                prefix=f".{path.name}.", suffix=".tmp", delete=False
            ) as stream:
                temp_path = Path(stream.name)
                stream.write(data)
                stream.flush()
                os.fsync(stream.fileno())
            os.replace(temp_path, path)
        finally:
            if temp_path and temp_path.exists():
                try:
                    temp_path.unlink()
                except OSError:
                    pass

    @staticmethod
    def append_jsonl(path: Path, record: dict) -> None:
        """Append one durable JSONL record without exposing a half-written line."""
        path.parent.mkdir(parents=True, exist_ok=True)
        line = json.dumps(record, ensure_ascii=False) + "\n"
        with path.open("a", encoding="utf-8", newline="\n") as stream:
            stream.write(line)
            stream.flush()
            os.fsync(stream.fileno())

    def update_current_position(self, course_id: str, next_action: str, gate: str | None = None) -> None:
        state_path = self.memory_root / "当前状态.json"
        state = self.load_json_file(state_path, {})
        course = self.course_record(course_id)
        position = state.setdefault("current_position", {})
        position.update({"course_id": course_id, "course_title": course.get("title", course_id), "next_action": next_action})
        if gate:
            position["gate"] = gate
        state["updated_at"] = datetime.now().astimezone().isoformat(timespec="seconds")
        self.save_json_file(state_path, state)

    def queue_english_review(self, record: dict, correct: bool, error_type: str) -> None:
        queue_path = self.memory_root / "复习队列.json"
        payload = self.load_json_file(queue_path, {"schema_version": "review-queue-v1", "policy": {"spacing_days": [1, 3, 7, 14, 30, 60]}, "items": []})
        items = payload.setdefault("items", [])
        item_id = record.get("exercise_id", f"{record.get('course_id', 'PRE0')}-ENGLISH")
        item = next((candidate for candidate in items if candidate.get("id") == item_id), None)
        now = datetime.now().astimezone()
        if item is None:
            item = {"id": item_id, "course_id": record.get("course_id", "PRE0"), "kind": "英语", "reason": "同步词汇、拼写、语序和短写作", "priority": "normal", "review_count": 0, "status": "queued"}
            items.append(item)
        item["last_result"] = "correct" if correct else "needs_review"
        item["error_type"] = error_type
        item["last_answer"] = record.get("answer", "")[:500]
        item["last_seen"] = now.date().isoformat()
        item["review_count"] = int(item.get("review_count", 0)) + 1
        item["due"] = now.date().isoformat() if not correct else (now + __import__("datetime").timedelta(days=min(60, max(1, item["review_count"] * 3)))).date().isoformat()
        item["status"] = "queued"
        payload["updated_at"] = now.isoformat(timespec="seconds")
        self.save_json_file(queue_path, payload)

    def classify_english(self, answer: str, expected: str) -> tuple[bool, str]:
        normalized_answer = " ".join(answer.lower().split()).strip(" .!?。！")
        normalized_expected = " ".join(expected.lower().split()).strip(" .!?。！")
        if normalized_expected and normalized_answer == normalized_expected:
            return True, "none"
        if normalized_expected and sorted(normalized_answer.split()) == sorted(normalized_expected.split()):
            return False, "word_order"
        if len(normalized_expected.split()) == 1 and normalized_answer and abs(len(normalized_answer) - len(normalized_expected)) <= 2:
            return False, "spelling"
        if normalized_expected and (normalized_answer.startswith(normalized_expected.split()[0]) or normalized_expected.startswith(normalized_answer.split()[0] if normalized_answer else "")):
            return False, "grammar"
        return False, "meaning_or_recall"

    @staticmethod
    def screen_concept(answer: str) -> tuple[int, list[str]]:
        lowered = answer.lower()
        signals = {
            "input": any(term in lowered for term in ("input", "输入", "键盘", "按键", "字母a", "letter a")),
            "process": any(term in lowered for term in ("process", "处理", "cpu", "操作系统", "程序", "识别")),
            "output": any(term in lowered for term in ("output", "输出", "屏幕", "显示", "看到a", "letter appears")),
        }
        missing = [name for name, present in signals.items() if not present]
        return round((len(signals) - len(missing)) / len(signals) * 100), missing

    @staticmethod
    def screen_module(answer: str, rubric_terms: list[str] | None = None) -> tuple[int, list[str]]:
        """Give a gentle, explainable pre-screen for one integrated module answer."""
        text = str(answer or "").strip()
        terms = [str(term).strip() for term in (rubric_terms or []) if str(term).strip()]
        score = 0
        notes: list[str] = []
        if len(text) >= 12:
            score += 35
        else:
            notes.append("请至少写一句完整观察或解释（12 个字符以上）。")
        matched = [term for term in terms if term.lower() in text.lower()]
        if terms:
            score += min(45, round(45 * len(matched) / len(terms)))
            missing = [term for term in terms if term not in matched]
            if missing:
                notes.append("再补充这些关键词中的至少一个：" + "、".join(missing[:3]) + "。")
        else:
            score += 45
        if any(mark in text for mark in ("因为", "所以", "因此", "观察", "证据", "because", "therefore", "evidence")):
            score += 20
        else:
            notes.append("补一句‘为什么’或指出你看到的证据。")
        return min(100, score), notes

    @staticmethod
    def beginner_module_text(index: int, layer: dict) -> str:
        """Give a plain-language bridge before the dense expert contract."""
        bridges = {
            1: "先不用背大词。我们只回答一个小问题：这节课学完，你能让电脑做什么，并且能说出怎样算做对？",
            2: "学习像搭积木。先检查已经会的那一块；如果不会，我们先补这一小块，再继续，不跳过基础。",
            3: "先用生活中的例子建立方向，再把例子换成真正的电脑对象。比喻只是拐杖，最后要回到事实和证据。",
            4: "现在轮到动手。每一步都先看输入，再看电脑发生了什么，最后看屏幕、文件或命令输出的结果。",
            5: "不要只记‘怎么做’，还要问‘为什么这样做’。我们把一个动作拆成几个小变化，逐个找证据。",
            6: "深挖就是只改变一个条件，再比较结果。这样才能知道真正的原因，而不是把巧合当规律。",
            7: "现在站高一点，看两种方案各自牺牲了什么。高手不只说哪一个更快，还要说它在什么条件下更合适。",
            8: "安全先于速度。只在自己的文件、合成数据和隔离环境里练习，遇到不确定就停下来问老师。",
            9: "验收不看‘我感觉懂了’，而看别人能不能按你的记录重做，并得到可以解释的结果。",
            10: "故障不是失败，而是实验材料。我们故意制造一个很小、能恢复的错误，再练习找原因和修复。",
            11: "最后把今天的知识接到下一节和毕业项目，并写下一个现在还不知道、值得继续研究的问题。",
        }
        return bridges.get(index, "我们把这个模块拆成一个小目标、一个动作和一个可以检查的结果。")

    def module_english_bundle(self, course_id: str, index: int, layer: dict) -> dict:
        """Attach one small, module-specific English lesson to every CS layer.

        The course-level lesson owns the vocabulary plan.  This method slices that
        plan into a distinct teach/practice bundle for each lecture layer, so the
        learner sees English at the exact point where the related computer concept
        is taught instead of seeing the same generic word list eleven times.
        """
        lesson = self.generated_english_lesson(course_id)
        stage = lesson.get("stage", {}) if isinstance(lesson, dict) else {}
        syllabus = lesson.get("syllabus", {}) if isinstance(lesson, dict) else {}
        raw_words = syllabus.get("words", []) if isinstance(syllabus, dict) else []
        words = []
        for raw in raw_words:
            if isinstance(raw, dict):
                word, meaning = str(raw.get("word", "")).strip(), str(raw.get("meaning", "")).strip()
            elif isinstance(raw, (list, tuple)) and raw:
                word, meaning = str(raw[0]).strip(), str(raw[1] if len(raw) > 1 else "本课词汇").strip()
            else:
                word, meaning = str(raw).strip(), "本课词汇"
            if word:
                words.append({"word": word, "meaning": meaning or "本课词汇"})
        if not words:
            words = [{"word": "computer", "meaning": "电脑"}]
        # A rotating window makes all eleven modules useful and prevents duplicate
        # cards while preserving at least two words in a very small A0 lesson.
        width = 3 if len(words) >= 3 else len(words)
        start = ((max(1, index) - 1) * width) % len(words)
        selected = [words[(start + offset) % len(words)] for offset in range(width)]
        selected = list({item["word"]: item for item in selected}.values())
        pronunciation_items = self.pronunciation_asset().get("items", {})
        for item in selected:
            pronunciation = pronunciation_items.get(item["word"], {}) if isinstance(pronunciation_items, dict) else {}
            item["ipa"] = self.pronunciation_for_word(item["word"]) or pronunciation.get("ipa", "")
        stage_id = str(stage.get("id", "A0"))
        lead = selected[0]
        second = selected[1] if len(selected) > 1 else lead
        if stage_id == "A0":
            grammar_by_module = {
                1: ("Letter → sound → word", "先认识字母和词的边界，不背术语。"),
                2: ("I am ... / You are ...", "I 用 am；you 用 are。"),
                3: ("This is a/an + noun.", "一个东西前面用 a 或 an，先模仿完整短句。"),
                4: ("I + verb + the + noun.", "先稳定‘谁 + 做什么 + 对什么做’。"),
                5: ("Is this a ...? Yes, it is.", "把陈述句变成最短的是非问答。"),
                6: ("The + noun + is ...", "用 is 说明一个对象在哪里或是什么。"),
                7: ("I can + verb.", "can 后面用动作原形，表达‘我能做’。"),
                8: ("There is a ...", "用 there is 指出眼前有一个东西。"),
                9: ("First ..., then ...", "用 first/then 说清两个步骤。"),
                10: ("I see ... / I do not see ...", "练习肯定和否定的最短观察句。"),
                11: ("Subject + verb + object.", "用一句话复述输入、动作和结果。"),
            }
            pattern, explanation = grammar_by_module.get(index, grammar_by_module[11])
            sentences = {
                1: "This is a computer.", 2: "I am here.", 3: "This is a file.",
                4: "I open the file.", 5: "Is this a file?", 6: "The file is here.",
                7: "I can type.", 8: "There is a key.", 9: "First, click. Then, type.",
                10: "I see the screen.", 11: "The computer shows a result.",
            }
            sentence = sentences.get(index, "I use the computer.")
        elif stage_id in ("A1", "A2"):
            pattern, explanation = ("Subject + verb + object + because ...", "把一个电脑动作和原因连成清楚的短段落。")
            sentence = f'The program displays the word "{lead["word"]}" and shows a result.'
        elif stage_id == "B1":
            pattern, explanation = ("If + condition, subject + verb + result.", "用条件句写工程行为、故障现象和修复结果。")
            sentence = f'If you enter the word "{lead["word"]}", the program reports an error.'
        else:
            pattern, explanation = ("Although + limitation, the evidence suggests that + claim.", "用限定、证据和谨慎语气表达研究结论。")
            sentence = f'The evidence includes the word "{lead["word"]}" in the sample.'
        if stage_id == "A0":
            translation_map = {
                "This is a computer.": "这是一台电脑。", "I am here.": "我在这里。", "This is a file.": "这是一个文件。",
                "I open the file.": "我打开这个文件。", "Is this a file?": "这是一个文件吗？", "The file is here.": "文件在这里。",
                "I can type.": "我会打字。", "There is a key.": "这里有一个按键。", "First, click. Then, type.": "先点击，然后输入。",
                "I see the screen.": "我看见屏幕。", "The computer shows a result.": "电脑显示一个结果。",
            }
            translation = translation_map.get(sentence, "先逐词理解，再用中文说出整句意思。")
        elif stage_id in ("A1", "A2"):
            translation = f"程序使用{lead['meaning']}并显示{second['meaning']}。"
        elif stage_id == "B1":
            translation = f"如果{lead['meaning']}无效，程序就报告错误。"
        else:
            translation = f"尽管{lead['meaning']}有限，证据仍支持该方法。"
        return {
            "words": selected,
            "article": f"{pattern} · {explanation}",
            "grammar": {"pattern": pattern, "explanation": explanation},
            "sentence": sentence,
            "translation": translation,
            "beginner_explanation": "先听老师读，再跟读；不会时可以先照着输入，之后遮住英文独立回忆。",
            "pronunciation": {
                "accent": "en-GB",
                "listen_text": " ".join(item["word"] for item in selected),
                "practice": "听一遍 → 慢速跟读两遍 → 看字母独立拼写 → 再读一遍",
            },
            "practice": [
                "听音并指出本模块词汇",
                "遮住中文，回忆一个词的意思",
                "在键盘上独立拼写 lead 词",
                "按句型替换一个词并提交",
            ],
        }

    @staticmethod
    def pronunciation_for_word(word: str) -> str:
        """Return a conservative IPA fallback for the starter vocabulary.

        The browser's speech engine remains the audio source; IPA is displayed as
        a reading aid and is intentionally left blank for unknown technical forms.
        """
        ipa = {
            "i": "/aɪ/", "you": "/juː/", "he": "/hiː/", "she": "/ʃiː/", "we": "/wiː/", "they": "/ðeɪ/",
            "a": "/ə/", "an": "/ən/", "the": "/ðə/", "this": "/ðɪs/", "that": "/ðæt/", "is": "/ɪz/", "am": "/æm/", "are": "/ɑː/",
            "my": "/maɪ/", "your": "/jɔː/", "name": "/neɪm/", "computer": "/kəmˈpjuːtə/", "screen": "/skriːn/", "key": "/kiː/",
            "mouse": "/maʊs/", "file": "/faɪl/", "folder": "/ˈfəʊldə/", "open": "/ˈəʊpən/", "close": "/kləʊz/", "click": "/klɪk/",
            "type": "/taɪp/", "read": "/riːd/", "write": "/raɪt/", "see": "/siː/", "go": "/ɡəʊ/", "here": "/hɪə/", "there": "/ðeə/",
            "yes": "/jes/", "no": "/nəʊ/", "one": "/wʌn/", "two": "/tuː/", "in": "/ɪn/", "on": "/ɒn/", "and": "/ænd/", "not": "/nɒt/",
            "can": "/kæn/", "do": "/duː/", "what": "/wɒt/", "where": "/weə/", "hello": "/həˈləʊ/", "good": "/ɡʊd/", "day": "/deɪ/",
            "it": "/ɪt/", "works": "/wɜːks/", "show": "/ʃəʊ/", "input": "/ˈɪnpʊt/", "output": "/ˈaʊtpʊt/", "data": "/ˈdeɪtə/", "save": "/seɪv/", "run": "/rʌn/", "error": "/ˈerə/",
        }
        return ipa.get(str(word).lower(), "")

    @staticmethod
    def pronunciation_status(word: str) -> str:
        return "verified-starter-ipa" if ClassroomHandler.pronunciation_for_word(word) else "speech-engine-required"

    @staticmethod
    def word_example(word: str, meaning: str, stage_id: str) -> tuple[str, str]:
        """Build one grammatical, level-appropriate sentence for a word card."""
        w = str(word).lower()
        if stage_id == "A0":
            fixed = {
                "i": ("I am here.", "我在这里。"), "you": ("You are here.", "你在这里。"),
                "he": ("He is here.", "他在这里。"), "she": ("She is here.", "她在这里。"),
                "we": ("We are here.", "我们在这里。"), "they": ("They are here.", "他们在这里。"),
                "a": ("This is a computer.", "这是一台电脑。"), "an": ("This is an input.", "这是一个输入。"),
                "the": ("The computer is here.", "电脑在这里。"), "this": ("This is a file.", "这是一个文件。"),
                "that": ("That is a screen.", "那是一个屏幕。"), "is": ("The file is here.", "文件在这里。"),
                "am": ("I am ready.", "我准备好了。"), "are": ("You are ready.", "你准备好了。"),
                "my": ("My name is Alex.", "我的名字是 Alex。"), "your": ("Your name is clear.", "你的名字很清楚。"),
                "name": ("My name is Alex.", "我的名字是 Alex。"), "computer": ("This is a computer.", "这是一台电脑。"),
                "screen": ("I see the screen.", "我看见屏幕。"), "key": ("I press a key.", "我按下一个按键。"),
                "mouse": ("I use the mouse.", "我使用鼠标。"), "file": ("I open the file.", "我打开文件。"),
                "folder": ("The file is in the folder.", "文件在文件夹里。"), "open": ("I open the file.", "我打开文件。"),
                "close": ("I close the file.", "我关闭文件。"), "click": ("I click the button.", "我点击按钮。"),
                "type": ("I type a word.", "我输入一个单词。"), "read": ("I read the word.", "我读这个单词。"),
                "write": ("I write a word.", "我写一个单词。"), "see": ("I see the screen.", "我看见屏幕。"),
                "go": ("I go here.", "我到这里来。"), "here": ("The file is here.", "文件在这里。"),
                "there": ("The folder is there.", "文件夹在那里。"), "yes": ("Yes, it is.", "是的，它是。"),
                "no": ("No, it is not.", "不，它不是。"), "one": ("I see one key.", "我看见一个按键。"),
                "two": ("I see two keys.", "我看见两个按键。"), "in": ("The file is in the folder.", "文件在文件夹里。"),
                "on": ("The key is on the keyboard.", "按键在键盘上。"), "and": ("I click and type.", "我点击并输入。"),
                "not": ("I do not click.", "我不点击。"), "can": ("I can type.", "我会打字。"),
                "do": ("I do the task.", "我做这个任务。"), "what": ("What is this?", "这是什么？"),
                "where": ("Where is the file?", "文件在哪里？"), "hello": ("Hello, computer.", "你好，电脑。"),
                "good": ("This is good.", "这很好。"), "day": ("Good day.", "祝你今天愉快。"),
                "it": ("It works.", "它运行正常。"), "works": ("It works.", "它运行正常。"),
                "show": ("The screen shows a result.", "屏幕显示一个结果。"), "input": ("I type the input.", "我输入信息。"),
                "output": ("The screen shows the output.", "屏幕显示输出。"), "data": ("The program uses data.", "程序使用数据。"),
                "save": ("I save the file.", "我保存文件。"), "run": ("I run the program.", "我运行程序。"),
                "error": ("I see an error.", "我看见一个错误。"),
            }
            if w in fixed:
                return fixed[w]
        # This neutral frame is grammatical for nouns, verbs, and specialist terms;
        # it keeps an unfamiliar word visible without inventing a false definition.
        return (f"The computer uses the word {w}.", f"电脑使用单词 {meaning}。")

    def pronunciation_asset(self) -> dict:
        if self._pronunciation_cache is None:
            self._pronunciation_cache = self.load_json_file(self.classroom_root / "英语发音_20k.json", {"items": {}, "source": "browser speech fallback"})
        return self._pronunciation_cache

    def vocabulary_plan(self) -> dict:
        if self._vocabulary_plan_cache is None:
            self._vocabulary_plan_cache = self.load_json_file(self.classroom_root / "英语课程_590课词汇计划.json", {"lessons": []})
        return self._vocabulary_plan_cache

    def grammar_plan(self) -> dict:
        """Load the explicit 590-lesson grammar route.

        Stage summaries remain useful for orientation, but this asset is the
        auditable source of truth for the actual lesson grammar: every course
        has a primary topic, spaced reviews, a model sentence, contrastive
        warning and mastery check.
        """
        if self._grammar_plan_cache is None:
            self._grammar_plan_cache = self.load_json_file(
                self.classroom_root / "英语语法课程_590课.json",
                {"topics": [], "lessons": [], "topic_count": 0, "lesson_count": 0},
            )
        return self._grammar_plan_cache

    def grammar_for_course(self, course_id: str) -> dict:
        payload = self.grammar_plan()
        lessons = payload.get("lessons", []) if isinstance(payload, dict) else []
        return next((item for item in lessons if item.get("course_id") == course_id), {})

    def integrated_modules(self, course_id: str) -> list[dict]:
        """Return lesson modules with a beginner bridge and stable IDs for in-page evidence."""
        summary = self.contract_summary(course_id)
        modules = []
        for index, layer in enumerate(summary.get("layers", []), 1):
            item = dict(layer)
            item["index"] = index
            item["id"] = f"module-{index:02d}"
            item["beginner"] = self.beginner_module_text(index, layer)
            modules.append(item)
        return modules

    def load_contracts(self) -> list[dict]:
        """Read the generated per-course contracts without treating them as learner evidence."""
        if self._contract_cache is not None:
            return self._contract_cache
        contract_path = self.memory_root.parent / "逐课专属深度合同_590课.json"
        try:
            payload = json.loads(contract_path.read_text(encoding="utf-8"))
            self._contract_cache = payload if isinstance(payload, list) else payload.get("courses", [])
            self._contract_by_id = {str(item.get("Id")): item for item in self._contract_cache}
            return self._contract_cache
        except (OSError, json.JSONDecodeError):
            return []

    def course_contract(self, course_id: str) -> dict:
        if self._contract_by_id is None:
            self.load_contracts()
        return (self._contract_by_id or {}).get(course_id, {})

    @staticmethod
    def gate_guide(index: int, text: str) -> dict:
        guides = {
            1: ("老师讲解：这一关是新手村。你先用自己的话说清楚‘电脑收到了什么、做了什么、出现了什么结果’，不需要专业术语。", ["先读本课最简单解释。", "找一个身边或课堂中的具体例子。", "按‘输入 → 变化 → 输出’写三句话。", "回到页面检查有没有写出可观察的结果。", "提交后等待自动预审和老师批改。"]),
            2: ("老师讲解：这一关练预测。真正理解不是看完答案，而是运行前先猜，再用结果比较。", ["先写运行前你认为会发生什么。", "写出你猜测的理由。", "执行本关要求的最小操作。", "把预测和实际结果并排比较。", "说明猜错的地方以及新认识。"]),
            3: ("老师讲解：这一关练动手。每一步都要留下证据，不能只写‘成功了’。", ["准备独立的小文件或安全练习目录。", "只执行题目要求的最小命令或操作。", "记录原始输入、输出和退出状态。", "用一句话解释输出为什么出现。", "清理临时文件，再提交证据。"]),
            4: ("老师讲解：这一关练解释机制。你要把‘看见的现象’和‘背后的原因’分开写。", ["先写观察到的现象。", "再写你认为发生的内部变化。", "指出哪一条证据支持这个解释。", "写出一个可能推翻你的条件。", "提交解释和证据路径。"]),
            5: ("老师讲解：这一关练迁移。把今天的知识换到一个新例子里，证明你不是只记住原题。", ["选择一个与本课不同但相关的新例子。", "先预测新例子的输入和结果。", "实际运行或构造可验证的演示。", "比较新旧例子的相同点和不同点。", "写出边界、限制和下一步问题。"]),
        }
        explanation, steps = guides.get(index, guides[5])
        return {"teacher_explanation": explanation, "steps": steps, "source_prompt": text}

    @staticmethod
    def lab_guide(index: int, name: str) -> dict:
        return {
            "teacher_explanation": f"老师讲解：Lab {index} 是一个小型安全实验。我们不追求一次做得快，而是让别人能按你的记录重做并得到相同结果。",
            "steps": [
                "先读实验名称、输入、预期结果和失败条件。",
                "只在自己的练习目录或隔离环境中准备材料。",
                "执行最小实验，保留原始命令或操作记录。",
                "记录实际输出、退出码、截图或生成文件。",
                "把实际结果和预期结果逐项比较。",
                "解释成功或失败的原因，写出一个修复或下一步。",
                "清理临时材料后，在证据框提交完整记录。",
            ],
            "source_name": name,
        }

    @staticmethod
    def checkpoint_guide(index: int, prompt: str) -> dict:
        return {
            "teacher_explanation": f"老师讲解：这是第 {index} 个检查点，不是背诵题。你要用自己的话回答，并拿出本节练习或 Lab 的证据。",
            "steps": [
                "先把题目改写成你听得懂的小问题。",
                "写出你的直接答案，不要先追求术语漂亮。",
                "补一个具体例子、实验输出或文件证据。",
                "说明答案成立的条件和不适用的地方。",
                "最后用一句话写出你还不会的部分，再提交。",
            ],
            "source_prompt": prompt,
        }

    @staticmethod
    def defense_guide(index: int, prompt: str) -> dict:
        return {
            "question": prompt,
            "teacher_explanation": "老师讲解：答辩不是要求你装成专家，而是练习把结论、证据、限制和下一步说清楚。",
            "steps": [
                "先用一句话回答结论。",
                "再给出两条最重要的证据。",
                "主动说出一个限制或可能反例。",
                "回答‘如果换一个条件会怎样’。",
                "最后说出下一步实验或研究问题。",
            ],
            "source_prompt": prompt,
        }

    def contract_summary(self, course_id: str) -> dict:
        if course_id in self._summary_cache:
            return self._summary_cache[course_id]
        contract = self.course_contract(course_id)
        if not contract:
            result = {"course_id": course_id, "available": False, "levels": [], "labs": [], "layers": [], "checkpoints": [], "oral_defense": [], "source": {}}
            self._summary_cache[course_id] = result
            return result
        levels = contract.get("Levels", [])
        labs = contract.get("Labs", [])
        layers = contract.get("LectureLayers", [])
        checkpoints = contract.get("Checkpoints", [])
        result = {
            "course_id": course_id,
            "available": True,
            "title": contract.get("Title", course_id),
            "category": contract.get("Category", ""),
            "topic_focus": contract.get("TopicFocus", ""),
            "prerequisites": contract.get("Previous", ""),
            "mechanism": contract.get("Mechanism", ""),
            "invariant": contract.get("Invariant", ""),
            "metric": contract.get("Metric", ""),
            "failure": contract.get("Failure", ""),
            "complexity": contract.get("Complexity", ""),
            "source": {"name": contract.get("Source", ""), "url": contract.get("Url", ""), "chapter": contract.get("SourceChapter", "")},
            "research_question": contract.get("ResearchQuestion", ""),
            "levels": [{"id": f"Lv{i + 1}", "text": str(level), **self.gate_guide(i + 1, str(level))} for i, level in enumerate(levels[:5])],
            "labs": [{"id": f"Lab{i + 1}", "name": lab.get("Name", f"Lab {i + 1}"), "input": lab.get("Input", ""), "expected": lab.get("Expected", ""), "failure": lab.get("Failure", ""), "metric": lab.get("Metric", ""), "evidence": lab.get("Evidence", ""), **self.lab_guide(i + 1, lab.get("Name", f"Lab {i + 1}"))} for i, lab in enumerate(labs[:5])],
            "layers": [{"id": f"module-{i + 1:02d}", "index": i + 1, "name": layer.get("Name", ""), "teaching": layer.get("Teaching", ""), "teacher_explanation": "老师讲解：" + self.beginner_module_text(i + 1, {"name": layer.get("Name", "")}) + " 现在我们把这个想法连接到一个真实的电脑动作，再用证据检查你是否真的看到了它。", "action": layer.get("Action", ""), "evidence": layer.get("Evidence", ""), "beginner": self.beginner_module_text(i + 1, {"name": layer.get("Name", "")})} for i, layer in enumerate(layers[:11])],
            "checkpoints": [{"stage": cp.get("Stage", ""), "prompt": cp.get("Prompt", ""), "deliverable": cp.get("Deliverable", ""), "gate": cp.get("Gate", ""), **self.checkpoint_guide(i + 1, cp.get("Prompt", ""))} for i, cp in enumerate(checkpoints[:5])],
            "oral_defense": [self.defense_guide(i + 1, str(item)) for i, item in enumerate(contract.get("OralDefense", [])[:5])],
            "controlled_variants": contract.get("ControlledVariants", [])[:3],
        }
        for layer in result["layers"]:
            layer["english"] = self.module_english_bundle(course_id, layer["index"], layer)
        self._summary_cache[course_id] = result
        return result

    def generated_lesson(self, course_id: str) -> dict:
        course = self.course_record(course_id)
        title = str(course.get("title", course_id))
        topic = str(course.get("topic_focus", title))
        contract = self.contract_summary(course_id)
        return {
            "lesson_id": f"{course_id}-generated-01",
            "course_id": course_id,
            "title": f"{title} / {topic}",
            "question_turn_index": 5,
            "question_prompt": f"What is the input, the process, and the output in {course_id}?\n在 {course_id} 这节课中，什么是输入、处理和输出？",
            "english_coaching": "Start with a short sentence: Subject + verb + object. 先写最短主动句：主语 + 动词 + 宾语。",
            "turns": [
                {"language": "en", "text": f"Welcome to {course_id}. Today we study {title}. We will begin with one small idea and build it carefully."},
                {"language": "zh", "text": f"欢迎来到 {course_id}。今天我们学习“{title}”。我们先从一个小概念开始，再逐步把它建立完整。"},
                {"language": "en", "text": f"The topic is {topic}. First, identify the input, the process, and the observable output. This pattern will help you think like an engineer."},
                {"language": "zh", "text": f"本课主题是“{topic}”。先找出输入、处理和可观察的输出，这个模式会帮助你建立工程师的思维。"},
                {"language": "en", "text": "Before we run an example, make a prediction. Use your own words, and do not worry about being perfect."},
                {"language": "zh", "text": "在运行例子之前先做预测。用你自己的话回答，不需要一开始就完美。"},
                {"language": "en", "text": "After your prediction, we will test the idea, explain the mechanism, and record what the evidence proves and does not prove."},
                {"language": "zh", "text": "你预测之后，我们会测试这个想法，解释机制，并记录证据证明了什么、没有证明什么。"}
            ],
            "contract": contract,
        }

    def read_tail(self, path: Path, limit: int = 8) -> list[dict]:
        if not path.exists():
            return []
        records: list[dict] = []
        for line in path.read_text(encoding="utf-8").splitlines()[-limit:]:
            try:
                records.append(json.loads(line))
            except json.JSONDecodeError:
                continue
        return records

    def report_for(self, start: int, end: int) -> dict:
        courses = self.load_courses()
        start = max(1, start)
        end = min(len(courses), max(start, end))
        selected = courses[start - 1:end]
        state_path = self.memory_root / "当前状态.json"
        try:
            state = json.loads(state_path.read_text(encoding="utf-8"))
        except (OSError, json.JSONDecodeError):
            state = {}
        current = state.get("current_position", {})
        answered = 0
        independent_answers = 0
        english = 0
        independent_english = 0
        error_types: dict[str, int] = {}
        evidence_submissions = 0
        for course in selected:
            cid = str(course.get("id", ""))
            answer_records = self.read_tail(self.memory_root / "课堂记录" / "课堂回答" / f"{cid}.jsonl", 1000)
            english_records = self.read_tail(self.memory_root / "课堂记录" / "英语练习" / f"{cid}.jsonl", 1000)
            answered += len(answer_records)
            independent_answers += len({(item.get("question_id"), item.get("answer", "").strip()) for item in answer_records})
            english += len(english_records)
            independent_english += len({(item.get("exercise_id"), item.get("answer", "").strip()) for item in english_records})
            for item in english_records:
                error_type = item.get("error_type")
                if error_type and error_type != "none":
                    error_types[error_type] = error_types.get(error_type, 0) + 1
            evidence_submissions += len(self.read_tail(self.memory_root / "课堂记录" / "关卡验收" / f"{cid}.jsonl", 1000)) + len(self.read_tail(self.memory_root / "课堂记录" / "Lab验收" / f"{cid}.jsonl", 1000))
        report = {
            "report_id": f"{start:03d}-{end:03d}",
            "course_range": [start, end],
            "course_count": len(selected),
            "courses": [{"id": c.get("id"), "title": c.get("title"), "topic_focus": c.get("topic_focus")} for c in selected],
            "evidence": {"concept_answers": answered, "independent_concept_answers": independent_answers, "english_submissions": english, "independent_english_submissions": independent_english, "evidence_submissions": evidence_submissions, "learner_gates_passed": 0, "learner_labs_passed": 0},
            "english_error_types": error_types,
            "current_position": current,
            "teacher_summary": "这是学习计划与证据快照，不把机器基线当作学习者掌握。每十节课完成后，老师会根据原回答、实验输出、英语错误和独立复述写个人报告。",
            "next_actions": ["完成本组课程的概念预测", "先复习错误最多的英语类型：" + (max(error_types, key=error_types.get) if error_types else "词义与语序"), "提交至少一个真实 Lab 证据包", "由老师人工验收后再升级"]
        }
        report_dir = self.memory_root / "十课报告"
        report_dir.mkdir(parents=True, exist_ok=True)
        report_path = report_dir / f"报告-{start:03d}-{end:03d}.json"
        self.save_json_file(report_path, report)
        return report

    def english_stage_for(self, course_id: str) -> dict:
        """Map the ordered course route to an explicit English progression."""
        courses = self.load_courses()
        index = next((i + 1 for i, item in enumerate(courses) if str(item.get("id")) == course_id), 1)
        stage = next((item for item in self.ENGLISH_ROADMAP if item["course_start"] <= index <= item["course_end"]), self.ENGLISH_ROADMAP[-1])
        return {**stage, "course_index": index, "total_courses": len(courses) or 590}

    @classmethod
    def english_curriculum(cls) -> dict:
        return {
            "target_words": 20000,
            "stages": cls.ENGLISH_ROADMAP,
            "policy": {
                "each_lesson": ["按阶段递进的新词（A0 每课 10 个；全路线 20,000 个去重词形）", "间隔复习词", "英式读音听辨与跟读", "英文认读与中英回忆", "键盘拼写/听写", "语序与语法", "英译中与中译英", "阅读理解", "阶段适配的短句、段落或论文写作"],
                "strands": ["recognition", "meaning_recall", "spelling", "pronunciation", "listening", "word_order", "grammar", "translation", "reading", "academic_writing"],
                "grammar_asset": "英语语法课程_590课.json",
                "grammar_policy": "每课一个主语法主题 + 间隔复习主题；每个主题包含结构、白话解释、例句、易混点、平台任务和掌握标准。覆盖 A0–C2+ 核心现代英语与计算机学术写作语法。",
                "pronunciation_policy": {
                    "target": "en-GB reference pronunciation",
                    "asset": "英语发音_20k.json",
                    "entries": 20000,
                    "loop": ["听辨", "IPA/重音", "慢速跟读", "正常速度复述", "键盘拼写", "自录回放与老师反馈"],
                    "honesty": "平台可以训练并测量这些证据，但不能保证任何人达到绝对零口音；口音会受母语、听力、身体和语音环境影响。",
                },
                "promotion": "完成当前阶段的词汇、语法、阅读、翻译和写作证据后，再进入下一阶段；不以看过页面代替掌握。",
                "platform_only": "所有训练、草稿、提示、批改和复习都在课堂页面完成，不要求纸面作业。",
                "retrieval": "每题提交后即时反馈并进入本地间隔复习队列；开放式翻译/写作保留原答案，标记为待老师批改。",
            },
        }

    @classmethod
    def english_lesson_blueprint(cls, index: int, stage: dict) -> dict:
        """A deterministic English syllabus: prerequisites come before technical fluency."""
        if index <= 5:
            unit = ["字母与大小写", "键盘、空格和回车", "看到一个词：词边界", "读写自己的名字和电脑", "复习与第一次小测"][index - 1]
            words = [("I", "我"), ("you", "你"), ("a", "一个"), ("the", "这个/特定的"), ("computer", "电脑")]
            grammar = "字母、大小写、空格、句号；先能照着输入，不要求背复杂术语。"
            sentence = "I am here."
            translation = "我在这里。"
            task = "看着英文逐字输入，再独立输入 I am here."
        elif index <= 10:
            unit = ["I / you 与 be", "this / that", "a / an", "名词单复数", "复习：我的电脑"][index - 6]
            words = [("I", "我"), ("am", "是/在"), ("is", "是/在"), ("this", "这个"), ("computer", "电脑")]
            grammar = "I am；You are；This is a/an ...；一个东西和多个东西的区别。"
            sentence = "This is a computer."
            translation = "这是一台电脑。"
            task = "把 This is a computer. 输入两遍，再把 a 换成 an 的例子找出来。"
        elif index <= 20:
            unit = ["基本动作：open / click", "have / has", "位置：in / on", "简单疑问句", "否定句", "祈使句", "颜色与数字", "文件和文件夹", "课堂指令", "A0 小测"][index - 11]
            words = [("open", "打开"), ("click", "点击"), ("file", "文件"), ("folder", "文件夹"), ("in", "在里面")]
            grammar = "主语 + 动词 + 对象；Do you ...?；I do not ...；请用短句描述一个动作。"
            sentence = "I open the file."
            translation = "我打开这个文件。"
            task = "用键盘写 I open the file.，再把 file 换成 folder。"
        elif index <= 40:
            unit = ["一般现在时：我/你", "第三人称先不背规则，先听和模仿", "时间与顺序", "电脑部件词", "键盘输入", "屏幕输出", "声音与图片", "简单原因 because", "复述一个小流程", "A0 阶段验收"][index % 10]
            words = [("type", "输入/打字"), ("show", "显示"), ("screen", "屏幕"), ("key", "按键"), ("result", "结果")]
            grammar = "一般现在时的最短陈述句；and / because 连接两个简单意思。"
            sentence = "I type a key, and the screen shows a result."
            translation = "我输入一个按键，屏幕显示一个结果。"
            task = "先抄写短句，再用自己的一个电脑动作替换 type 或 result。"
        elif stage["id"] == "A1":
            unit = "基础交流与技术词：现在时、疑问、介词和常用电脑动作"
            words = [("run", "运行"), ("save", "保存"), ("read", "读取"), ("write", "写入"), ("error", "错误")]
            grammar = "一般现在时、第三人称单数、冠词、复数、疑问句和介词；先写 3–5 句。"
            sentence = "The program reads a file and shows an error."
            translation = "程序读取一个文件并显示一个错误。"
            task = "回答 What does the program read? 并写出一个自己的保存动作。"
        elif stage["id"] == "A2":
            unit = "连贯技术表达：过去、将来、情态、比较和因果"
            words = [("changed", "改变了"), ("will", "将会"), ("must", "必须"), ("because", "因为"), ("faster", "更快")]
            grammar = "过去/将来、can/must、比较级、because/when/if 和被动语态入门。"
            sentence = "The test failed because the input was empty."
            translation = "测试失败了，因为输入是空的。"
            task = "写 2–3 句说明现象、原因和下一步。"
        elif stage["id"] == "B1":
            unit = "工程沟通：文档、条件句、关系从句与故障报告"
            words = [("require", "要求"), ("allow", "允许"), ("failure", "失败"), ("reproduce", "复现"), ("trade-off", "取舍")]
            grammar = "复杂句、条件句、关系从句、被动语态和段落主题句。"
            sentence = "If the input is invalid, the program returns an error."
            translation = "如果输入无效，程序就返回错误。"
            task = "写一段 80–120 词的故障说明，明确条件、现象和修复。"
        elif stage["id"] == "B2":
            unit = "学术技术英语：论文结构、证据、不确定性与综述"
            words = [("claim", "主张"), ("evidence", "证据"), ("method", "方法"), ("result", "结果"), ("limitation", "局限")]
            grammar = "名词化、复杂被动、让步、定义、篇章连接和 hedging。"
            sentence = "The results suggest that the method is useful under these conditions."
            translation = "结果表明，在这些条件下该方法可能有用。"
            task = "写 150–250 词，区分主张、证据和局限。"
        elif stage["id"] == "C1":
            unit = "研究与批判表达：论证地图、变量、威胁与引用"
            words = [("assumption", "假设"), ("validity", "有效性"), ("bias", "偏差"), ("variable", "变量"), ("replicate", "复现")]
            grammar = "学术语域、限定表达、平行结构、复杂名词短语和引用规范。"
            sentence = "Although the sample is limited, the evidence supports the proposed explanation."
            translation = "尽管样本有限，证据仍支持所提出的解释。"
            task = "写一个研究问题、变量定义和威胁说明。"
        else:
            unit = "C2/C2+ 学术宗师：出版、审稿、教学和跨学科论证"
            words = [("contribution", "贡献"), ("robustness", "稳健性"), ("generalise", "推广"), ("replicability", "可复现性"), ("implication", "含义")]
            grammar = "出版级措辞、跨段论证、审稿回复、摘要、cover letter 和答辩。"
            sentence = "The contribution is limited to settings in which the stated assumptions hold."
            translation = "该贡献仅适用于所述假设成立的场景。"
            task = "完成一段可被反驳的论文论证，并写出限制、证据和下一步。"
        return {"course_index": index, "unit": unit, "words": [{"word": w, "meaning": m} for w, m in words], "grammar": grammar, "sentence": sentence, "translation": translation, "task": task, "stage": stage["id"]}

    def generated_english_lesson(self, course_id: str, seed: dict | None = None) -> dict:
        """Build a stage-sensitive, platform-only English lesson for any course."""
        self.load_courses()
        matrix_path = self.memory_root / "掌握矩阵.json"
        try:
            matrix = json.loads(matrix_path.read_text(encoding="utf-8"))
            courses = matrix if isinstance(matrix, list) else matrix.get("courses", [])
            course = next(item for item in courses if item.get("id") == course_id)
        except (OSError, json.JSONDecodeError, StopIteration):
            course = {"id": course_id, "title": course_id, "topic_focus": "computer science"}
        title = str(course.get("title", course_id))
        topic = str(course.get("topic_focus", title))
        stage = self.english_stage_for(course_id)
        syllabus = self.english_lesson_blueprint(int(stage["course_index"]), stage)
        grammar_record = self.grammar_for_course(course_id)
        if grammar_record:
            # Replace the broad stage slogan with this lesson's explicit
            # grammar contract.  The stage remains visible as the learner's
            # map; the record below is what the learner must actually practise.
            syllabus["grammar"] = f"{grammar_record.get('title', '本课语法')} · {grammar_record.get('pattern', '')}"
            syllabus["grammar_explanation"] = grammar_record.get("explanation", "")
            syllabus["grammar_contrast"] = grammar_record.get("contrast", "")
            syllabus["grammar_task"] = grammar_record.get("task", "")
            syllabus["grammar_mastery_check"] = grammar_record.get("mastery_check", "")
            syllabus["sentence"] = grammar_record.get("example", syllabus.get("sentence", ""))
            syllabus["translation"] = grammar_record.get("translation", syllabus.get("translation", ""))
            syllabus["grammar_topic_ids"] = grammar_record.get("grammar_topic_ids", [])
            syllabus["primary_grammar_topic_id"] = grammar_record.get("primary_topic_id", "")
        # The vocabulary plan is the auditable source of truth for the 590-course route.
        # Keep the hand-authored blueprint as a fallback so a missing/corrupt plan never
        # makes the classroom unavailable.
        plan_payload = self.vocabulary_plan()
        plan_lessons = plan_payload.get("lessons", []) if isinstance(plan_payload, dict) else []
        plan = next((item for item in plan_lessons if item.get("course_id") == course_id), None)
        if isinstance(plan, dict) and plan.get("new_words"):
            plan_new = [str(word).strip().lower() for word in plan.get("new_words", []) if str(word).strip()]
            plan_review = [str(word).strip().lower() for word in plan.get("review_words", []) if str(word).strip()]
            plan_words = plan_new + [word for word in plan_review if word not in plan_new]
            # Preserve the beginner lesson's meanings for its first words, and expose
            # the rest as planned vocabulary awaiting learner-side definition practice.
            meaning_map = {str(item["word"]).lower(): item["meaning"] for item in syllabus.get("words", [])}
            meaning_map.update({
                "i": "我", "you": "你", "he": "他", "she": "她", "we": "我们", "they": "他们",
                "a": "一个", "an": "一个（用于元音音素前）", "the": "这个/特定的", "this": "这个", "that": "那个",
                "is": "是/在", "am": "是/在", "are": "是/在", "my": "我的", "your": "你的", "name": "名字",
                "computer": "电脑", "screen": "屏幕", "key": "按键", "mouse": "鼠标", "file": "文件", "folder": "文件夹",
                "open": "打开", "close": "关闭", "click": "点击", "type": "输入/打字", "read": "读取/阅读", "write": "写入/书写",
                "see": "看见", "go": "去", "here": "这里", "there": "那里", "yes": "是", "no": "不",
                "one": "一", "two": "二", "in": "在里面", "on": "在上面", "and": "和", "not": "不",
                "can": "能够", "do": "做", "what": "什么", "where": "哪里", "hello": "你好", "good": "好的",
                "day": "天", "it": "它", "works": "工作/运行", "show": "显示", "input": "输入", "output": "输出",
                "data": "数据", "save": "保存", "run": "运行", "error": "错误",
            })
            syllabus["words"] = [{"word": word, "meaning": meaning_map.get(word.lower(), "本课词汇；提交后由老师确认词义")} for word in plan_words]
            syllabus["new_words"] = plan_new
            syllabus["review_words"] = plan_review
            syllabus["new_word_count"] = len(plan_new)
            syllabus["review_word_count"] = len(plan_review)
            syllabus["cumulative_word_target"] = int(plan.get("cumulative_word_target", 0))
            # Every planned word has a pronunciation practice slot.  The browser uses
            # the Web Speech API when available and still keeps a typed fallback.
            pronunciation_items = self.pronunciation_asset().get("items", {})
            pronunciation_lookup = {str(key).lower(): value for key, value in pronunciation_items.items()} if isinstance(pronunciation_items, dict) else {}
            syllabus["pronunciation"] = {
                "mode": "listen-repeat-self-check",
                "accent": "en-GB",
                "voice": "English (United Kingdom) when the browser provides it",
                "ipa_source": "英语发音_20k.json · 20,000 entries",
                "items": [{"word": word, "ipa": str(pronunciation_lookup.get(word, {}).get("ipa", "")), "sound_hint": "先听完整音 → 慢速跟读两遍 → 遮住单词拼写 → 再听并自查重音。"} for word in plan_words],
                "training_loop": ["听辨", "看 IPA 与重音", "慢速跟读", "正常速度复述", "键盘拼写", "记录最容易混淆的音"],
                "note": "浏览器提供 en-GB 播放和 IPA 参照；页面不伪造口音分数。真正的发音掌握要用听辨、跟读、自录回放和老师反馈反复验证。"
            }
            syllabus["review_cycle"] = [1, 3, 7, 14, 30, 60]
        if not seed:
            # Every card receives its own sentence, IPA where available, and the
            # same sentence's Chinese meaning.  The sentence is generated from the
            # current stage grammar and never falls back to "I am here.".
            pronunciation_items = self.pronunciation_asset().get("items", {})
            lesson_words = []
            for number, item in enumerate(syllabus["words"]):
                word, meaning = item["word"], item["meaning"]
                if stage["id"] == "A0":
                    example, translation = self.word_example(word, meaning, stage["id"])
                elif stage["id"] in ("A1", "A2"):
                    example = f'The program displays the word "{word}" and shows a result.'
                    translation = f'程序显示单词“{word}”，并显示一个结果。'
                elif stage["id"] == "B1":
                    example = f'If you enter the word "{word}", the program reports an error.'
                    translation = f'如果你输入单词“{word}”，程序就报告错误。'
                else:
                    example = f'The evidence includes the word "{word}" in the sample.'
                    translation = f'证据样本中包含单词“{word}”。'
                pronunciation = pronunciation_items.get(word, {}) if isinstance(pronunciation_items, dict) else {}
                # Prefer the hand-checked IPA for starter words; the generated
                # CMU-derived value covers the remaining planned vocabulary.
                ipa = self.pronunciation_for_word(word) or pronunciation.get("ipa", "")
                lesson_words.append({"word": word, "meaning": meaning, "ipa": ipa, "arpabet": pronunciation.get("arpabet", ""), "pronunciation_status": "verified" if pronunciation else self.pronunciation_status(word), "part_of_speech": "基础词/技术词", "example": example, "translation": translation})
            exercises = [
                {"id": f"{course_id}-EN-LISTEN-01", "type": "listening", "strand": "pronunciation", "prompt": "点击‘朗读题目’，听老师读本课第一个词，然后把你听到的英文输入。", "speak_text": syllabus["words"][0]["word"], "expected": syllabus["words"][0]["word"], "hint": "先听完整音，再按字母拼写；不会时可以重听。"},
                {"id": f"{course_id}-EN-SYLLABLE-01", "type": "recognition", "strand": "recognition", "prompt": f"看英文词 **{syllabus['words'][0]['word']}**，在中文输入框写出意思。", "expected": syllabus["words"][0]["meaning"], "hint": "先看词形，再看本模块短句。"},
                {"id": f"{course_id}-EN-TYPE-01", "type": "typing", "strand": "spelling", "prompt": f"在键盘上独立输入：{syllabus['sentence']}", "expected": syllabus["sentence"], "hint": "先按单词之间的空格，再检查句号。"},
                {"id": f"{course_id}-EN-PRON-01", "type": "pronunciation", "strand": "pronunciation", "prompt": f"点击‘朗读题目’，跟读这个词两遍，再输入它：{syllabus['words'][1]['word']}", "speak_text": syllabus["words"][1]["word"], "expected": syllabus["words"][1]["word"], "hint": "关注词尾音，不追求一次完美；先听、再跟读、最后拼写。"},
                {"id": f"{course_id}-EN-MEANING-01", "type": "meaning_recall", "strand": "meaning_recall", "prompt": f"把中文“{syllabus['words'][1]['meaning']}”写成英文单词。", "expected": syllabus["words"][1]["word"], "hint": "从本模块词汇卡中回忆，不要急着看答案。"},
                {"id": f"{course_id}-EN-GRAMMAR-01", "type": "grammar", "strand": "grammar", "prompt": f"本课语法：{syllabus['grammar']}。请先写出结构，再用自己的话说明它在短句中的作用。", "expected": "", "hint": "；".join(item for item in [syllabus["grammar"], syllabus.get("grammar_explanation", ""), syllabus.get("grammar_contrast", "")] if item), "review_mode": "teacher"},
                {"id": f"{course_id}-EN-TRANSLATE-01", "type": "translation_en_zh", "strand": "translation", "prompt": f"把英文翻译成中文：{syllabus['sentence']}", "expected": syllabus["translation"], "hint": "先找谁、做什么、对什么做。", "review_mode": "teacher"},
                {"id": f"{course_id}-EN-WRITE-01", "type": "short_writing", "strand": "academic_writing", "prompt": syllabus["task"], "expected": "", "hint": "先写最短、最清楚的句子；不会的词可以从词汇卡复制后再自己改写。", "review_mode": "teacher"},
            ]
            if stage["id"] in ("A0", "A1"):
                exercises.append({"id": f"{course_id}-EN-ORDER-01", "type": "word_order", "strand": "word_order", "prompt": f"把词排成正确句子：{syllabus['sentence']}", "expected": syllabus["sentence"], "hint": "先找主语，再找动作，最后找对象。"})
            else:
                exercises.append({"id": f"{course_id}-EN-READ-01", "type": "reading", "strand": "reading", "passage": syllabus["sentence"]+" "+syllabus["translation"], "prompt": "阅读本模块短文后，用英文写出一个关键词。", "expected": syllabus["words"][0]["word"], "hint": "回到短文中定位关键词。"})
            grammar_topics = []
            grammar_payload = self.grammar_plan()
            topic_by_id = {str(item.get("id")): item for item in grammar_payload.get("topics", []) if isinstance(item, dict)}
            for topic_id in syllabus.get("grammar_topic_ids", []):
                if topic_by_id.get(str(topic_id)):
                    grammar_topics.append(topic_by_id[str(topic_id)])
            grammar_detail = {
                "title": grammar_record.get("lesson_focus", syllabus.get("grammar", "")) if grammar_record else syllabus.get("grammar", ""),
                "pattern": grammar_record.get("pattern", syllabus.get("grammar", "")) if grammar_record else syllabus.get("grammar", ""),
                "explanation": syllabus.get("grammar_explanation", f"本课英语目标：{syllabus['unit']}。"),
                "example": syllabus["sentence"],
                "translation": syllabus["translation"],
                "contrast": syllabus.get("grammar_contrast", ""),
                "task": syllabus.get("grammar_task", syllabus.get("task", "")),
                "mastery_check": syllabus.get("grammar_mastery_check", ""),
                "topic_ids": syllabus.get("grammar_topic_ids", []),
                "topics": grammar_topics,
                "coverage": grammar_payload.get("coverage", "") if isinstance(grammar_payload, dict) else "",
            }
            return {"course_id": course_id, "title": f"Computer English · {title}", "level": f"{stage['id']} · {stage['label']}", "stage": {**stage, "unit": syllabus["unit"]}, "syllabus": syllabus, "words": lesson_words, "grammar": grammar_detail, "lesson_sentence": {"english": syllabus["sentence"], "chinese": syllabus["translation"]}, "exercises": exercises, "platform_routine": ["老师先用最简单的话解释", "听音、跟读并看本课新词和间隔复习词", "在输入框独立回忆并键盘拼写", "练语序、语法、翻译、阅读和短写作", "提交后看自动校对与老师批改，错误进入间隔复习"], "vocabulary_target": {"course_words": len(lesson_words), "new_words": len(syllabus.get('new_words', lesson_words)), "review_words": len(syllabus.get('review_words', [])), "cumulative_target": syllabus.get('cumulative_word_target', 0), "route_target": stage["word_target"], "overall_target": 20000, "source": "英语课程_590课词汇计划.json；计划量不等于已掌握量"}, "grammar_target": {"topic_count": len(grammar_topics), "primary_topic_id": syllabus.get("primary_grammar_topic_id", ""), "asset": "英语语法课程_590课.json"}}
        raw_terms = [term.strip() for term in topic.replace("/", ",").replace("（", ",").replace("）", "").split(",") if term.strip()]
        glossary = {
            "操作系统": "operating system", "数据库": "database", "计算机": "computer", "电脑": "computer",
            "输入": "input", "输出": "output", "内存": "memory", "存储": "storage", "文件夹": "folder", "文件": "file",
            "键盘": "keyboard", "鼠标": "mouse", "进程": "process", "变量": "variable", "名字标签": "label", "标签": "label", "盒子": "box",
            "类型": "type", "函数": "function", "循环": "loop", "条件": "condition", "算法": "algorithm", "网络": "network",
            "数据": "data", "安全": "security", "漏洞": "vulnerability", "模型": "model", "部署": "deployment", "容器": "container",
            "测试": "testing", "用户": "user", "网站": "website", "界面": "interface", "系统": "system", "结果": "result", "方法": "method"
        }
        terms = []
        seen_english = set()
        topic_text = " ".join(raw_terms)
        for key, english in sorted(glossary.items(), key=lambda item: len(item[0]), reverse=True):
            if key in topic_text and english not in seen_english:
                terms.append((english, key))
                seen_english.add(english)
        for term in raw_terms:
            english = term.lower()
            if any(ch.isascii() and ch.isalpha() for ch in term) and english not in seen_english:
                terms.append((english, term))
                seen_english.add(english)
        base_bank = [
            ("system", "系统", "noun"), ("data", "数据", "noun"), ("model", "模型", "noun"), ("result", "结果", "noun"),
            ("method", "方法", "noun"), ("evidence", "证据", "noun"), ("compare", "比较", "verb"), ("explain", "解释", "verb"),
            ("measure", "测量", "verb"), ("design", "设计", "verb"), ("test", "测试", "verb"), ("error", "错误", "noun"),
            ("cause", "原因", "noun"), ("effect", "影响", "noun"), ("secure", "安全的", "adjective"), ("reliable", "可靠的", "adjective"),
            ("variable", "变量", "noun"), ("function", "函数", "noun"), ("process", "处理；过程", "noun / verb"), ("output", "输出；结果", "noun"),
            ("input", "输入", "noun"), ("algorithm", "算法", "noun"), ("network", "网络", "noun"), ("memory", "内存", "noun"),
        ]
        seed = seed if isinstance(seed, dict) else {}
        seed_words = seed.get("words", []) if isinstance(seed.get("words", []), list) else []
        merged = []
        seen_words = set()
        for item in seed_words:
            if not isinstance(item, dict) or not str(item.get("word", "")).strip():
                continue
            word = str(item.get("word", "")).strip().lower()
            if word in seen_words:
                continue
            merged.append({"word": word, "meaning": str(item.get("meaning", "常用技术词")), "part_of_speech": str(item.get("part_of_speech", "term")), "example": str(item.get("example", f"We study {word}.")), "translation": str(item.get("translation", f"我们学习 {item.get('meaning', '这个词')}。"))})
            seen_words.add(word)
        topic_bank = [(word, meaning, "term") for word, meaning in terms]
        rotation = (int(stage["course_index"]) * 7) % len(base_bank)
        rotated_bank = base_bank[rotation:] + base_bank[:rotation]
        for word, meaning, pos in topic_bank + rotated_bank:
            if word in seen_words:
                continue
            merged.append({"word": word, "meaning": meaning, "part_of_speech": pos, "example": f"We study the {word}.", "translation": f"我们学习{meaning}。"})
            seen_words.add(word)
        words = merged[:12]
        while len(words) < 8:
            word, meaning, pos = base_bank[len(words) % len(base_bank)]
            words.append({"word": word, "meaning": meaning, "part_of_speech": pos, "example": f"We study the {word}.", "translation": f"我们学习{meaning}。"})
        lead = words[0]
        second = words[1]
        sentence = f"The system processes the {lead['word']} and produces a {second['word']}."
        zh_sentence = f"系统处理{lead['meaning']}并产生{second['meaning']}。"
        if stage["id"] in ("A0", "A1"):
            grammar = {"pattern": "Subject + verb + object", "explanation": stage["grammar_scope"] + "。先稳定英语基本语序：谁 + 做什么 + 对什么做。", "example": f"We study the {lead['word']}.", "translation": f"我们学习{lead['meaning']}。"}
        elif stage["id"] in ("A2", "B1"):
            grammar = {"pattern": "Because + clause, subject + verb + result", "explanation": stage["grammar_scope"] + "。用连接词表达原因、条件、时间和转折。", "example": f"Because the {lead['word']} changes, the {second['word']} changes.", "translation": f"因为{lead['meaning']}发生变化，所以{second['meaning']}也发生变化。"}
        else:
            grammar = {"pattern": "Although + limitation, the evidence suggests that + claim", "explanation": stage["grammar_scope"] + "。用限定语、被动语态和证据强度写学术论证。", "example": f"Although the {lead['word']} is limited, the evidence suggests that the method is reliable.", "translation": f"尽管{lead['meaning']}有局限，证据仍表明该方法是可靠的。"}
        exercises = [
            {"id": f"{course_id}-EN-RECOG-01", "type": "recognition", "strand": "recognition", "prompt": f"看到英文词 **{lead['word']}**，在输入框写出中文含义。", "expected": lead["meaning"], "hint": f"它出现在例句：{lead['example']}"},
            {"id": f"{course_id}-EN-MEAN-01", "type": "meaning_recall", "strand": "meaning_recall", "prompt": f"把中文“{second['meaning']}”写成英文单词。", "expected": second["word"], "hint": "先按发音分音节，再逐字母输入。"},
            {"id": f"{course_id}-EN-SPELL-01", "type": "spelling", "strand": "spelling", "prompt": f"键盘听写挑战：不复制页面文字，独立输入 **{words[2]['word']}**。", "expected": words[2]["word"], "hint": "输入完成后检查首字母、双写字母和词尾。"},
            {"id": f"{course_id}-EN-ORDER-01", "type": "word_order", "strand": "word_order", "prompt": f"把词语排成正确句子：{lead['word']} / the / studies / We", "expected": f"We study the {lead['word']}."},
            {"id": f"{course_id}-EN-GRAMMAR-01", "type": "grammar", "strand": "grammar", "prompt": f"补全句子：The computer ___ the {lead['word']}.（使用 process 的正确形式）", "expected": f"processes", "hint": "一般现在时中，第三人称单数主语后动词通常加 -s。"},
            {"id": f"{course_id}-EN-TRANS-01", "type": "translation_en_zh", "strand": "translation", "prompt": f"把英文翻译成中文：{sentence}", "expected": zh_sentence, "hint": "先找主语、动作、对象，再处理 and。", "review_mode": "teacher"},
            {"id": f"{course_id}-EN-TRANS-02", "type": "translation_zh_en", "strand": "translation", "prompt": f"把中文翻译成英文：{zh_sentence}", "expected": sentence, "hint": "先写 The system，再写 processes，最后补对象和结果。", "review_mode": "teacher"},
            {"id": f"{course_id}-EN-READ-01", "type": "reading", "strand": "reading", "passage": f"The {lead['word']} is an important part of the system. It receives data, follows a method, and produces a result.", "prompt": f"阅读短文后回答：What does the {lead['word']} produce? 用一个英文词回答。", "expected": "result"},
            {"id": f"{course_id}-EN-WRITE-01", "type": "short_writing", "strand": "academic_writing", "prompt": f"用英文写 1–2 句，说明 {lead['meaning']} 如何影响 {second['meaning']}。至少使用 because / so / although 之一。", "expected": "", "hint": "开放写作没有唯一字符串答案；先写清主语、动词、证据或因果。", "review_mode": "teacher"},
            {"id": f"{course_id}-EN-REWRITE-01", "type": "sentence_transform", "strand": "grammar", "prompt": f"改写为学术语气：The {lead['word']} is good. 使用 evidence suggests that。", "expected": f"The evidence suggests that the {lead['word']} is reliable.", "hint": "把口语化的 good 换成可测量、可限定的表达。", "review_mode": "teacher"},
        ]
        if stage["id"] in ("B2", "C1", "C2", "C2+"):
            exercises.extend([
                {"id": f"{course_id}-EN-SUMMARY-01", "type": "reading_summary", "strand": "academic_writing", "prompt": "用 3–5 句英文总结本课段落：研究对象、方法、结果和限制。", "expected": "", "hint": "使用 first, however, therefore, limitation 等衔接词。", "review_mode": "teacher"},
                {"id": f"{course_id}-EN-ABSTRACT-01", "type": "academic_paragraph", "strand": "academic_writing", "prompt": "写一个 80–120 词英文 mini-abstract：Background、Method、Result、Limitation 四部分都要出现。", "expected": "", "hint": "避免绝对化结论，使用 may / suggests / under these conditions。", "review_mode": "teacher"},
            ])
        return {"course_id": course_id, "title": f"Computer English · {title}", "level": f"{stage['id']} · {stage['label']}", "stage": stage, "words": words, "grammar": grammar, "lesson_sentence": {"english": sentence, "chinese": zh_sentence}, "exercises": exercises, "platform_routine": ["先看词义和例句", "在输入框独立回忆并提交", "根据反馈重试或查看提示", "完成语序、语法、翻译、阅读和写作", "提交后进入本地间隔复习队列"], "vocabulary_target": {"course_words": len(words), "route_target": stage["word_target"], "overall_target": 20000, "source": "本地技术词表 + 高频英语词表；每课新词与间隔复习由记录决定"}}

    def normalize_english_lesson(self, course_id: str, lesson: dict) -> dict:
        """Upgrade legacy JSON lessons while preserving their authored vocabulary."""
        generated = self.generated_english_lesson(course_id)
        if not isinstance(lesson, dict):
            return generated
        # Legacy files may contain useful authored examples, but they must not
        # override the ordered zero-to-academic syllabus unless explicitly upgraded.
        for key in ("course_id", "title"):
            if key in lesson and lesson[key]:
                generated[key] = lesson[key]
        if lesson.get("syllabus_version") == "v2" and isinstance(lesson.get("words"), list) and len(lesson["words"]) >= 3:
            generated["words"] = lesson["words"]
            generated["grammar"] = lesson.get("grammar") or generated["grammar"]
            generated["exercises"] = lesson.get("exercises") or generated["exercises"]
        if lesson.get("syllabus_version") == "v2" and lesson.get("stage"):
            generated["stage"] = lesson["stage"]
        if lesson.get("syllabus_version") == "v2" and lesson.get("platform_routine"):
            generated["exercises"] = lesson["exercises"]
        generated["platform_routine"] = lesson.get("platform_routine") if lesson.get("syllabus_version") == "v2" else generated["platform_routine"]
        generated["legacy_upgraded"] = bool(lesson.get("paper_routine") or lesson.get("legacy_paper_routine"))
        generated.pop("paper_routine", None)
        generated.pop("legacy_paper_routine", None)
        return generated

    def send_json(self, status: int, payload: dict) -> None:
        body = json.dumps(payload, ensure_ascii=False).encode("utf-8")
        self.send_response(status)
        self.send_header("Content-Type", "application/json; charset=utf-8")
        self.send_header("Content-Length", str(len(body)))
        self.send_header("Cache-Control", "no-store")
        self.end_headers()
        self.wfile.write(body)

    def end_headers(self) -> None:
        """Prevent an already-open classroom tab from retaining an old UI bundle."""
        path = self.path.split("?", 1)[0].lower()
        if path.endswith((".html", ".css", ".js")):
            self.send_header("Cache-Control", "no-store, max-age=0")
            self.send_header("Pragma", "no-cache")
        super().end_headers()

    def do_GET(self) -> None:
        """Expose the lesson and learner snapshot to the single classroom page."""
        parsed = urlparse(self.path)
        route = parsed.path
        if route == "/favicon.ico":
            self.send_response(204)
            self.send_header("Cache-Control", "no-store")
            self.end_headers()
            return
        if route == "/api/health":
            self.send_json(200, {"ok": True, "service": "local-classroom", "offline_ready": True})
            return
        if route == "/api/capabilities":
            local_files = {
                "course_matrix": (self.memory_root / "掌握矩阵.json").exists(),
                "course_contracts": (self.memory_root.parent / "逐课专属深度合同_590课.json").exists(),
                "english_lessons": any(self.classroom_root.glob("*-英语.json")),
                "english_grammar": (self.classroom_root / "英语语法课程_590课.json").exists(),
                "pronunciation_asset": (self.classroom_root / "英语发音_20k.json").exists(),
                "local_audio": (self.classroom_root / "PRE0-第一段-segments").exists(),
                "video_config": (self.classroom_root / "视频课件配置.json").exists(),
                "learner_state": (self.memory_root / "当前状态.json").exists(),
            }
            self.send_json(200, {
                "ok": True,
                "offline_ready": all(local_files.values()),
                "local_files": local_files,
                "available_offline": ["590 节课程目录", "已保存的英语课件", "已保存的学习记录", "浏览器英式英语语音回退", "本地音频（已有文件）"],
                "requires_internet": ["云端老师思考与批改", "官方课程页面和远程视频", "云端语音生成或替换声线"],
                "note": "断网不会影响本地课程和本机记录；联网功能失败时应保留文字并稍后重试。",
            })
            return
        if route == "/api/state":
            state_path = self.memory_root / "当前状态.json"
            try:
                state = json.loads(state_path.read_text(encoding="utf-8"))
                self.send_json(200, {"ok": True, "state": state})
            except (OSError, json.JSONDecodeError):
                self.send_json(500, {"ok": False, "message": "当前学习状态暂时无法读取"})
            return
        if route == "/api/lesson":
            course_id = self.course_id_from_query(parsed)
            lesson_path = self.classroom_root / f"{course_id}-第一段.json"
            try:
                lesson = json.loads(lesson_path.read_text(encoding="utf-8"))
                lesson.setdefault("course_id", course_id)
                lesson.setdefault("contract", self.contract_summary(course_id))
                self.send_json(200, {"ok": True, "lesson": lesson})
            except (OSError, json.JSONDecodeError):
                self.send_json(200, {"ok": True, "lesson": self.generated_lesson(course_id), "generated": True})
            return
        if route == "/api/contract":
            course_id = self.course_id_from_query(parsed)
            self.send_json(200, {"ok": True, "contract": self.contract_summary(course_id)})
            return

        if route == "/api/navigation":
            course_id = self.course_id_from_query(parsed)
            self.send_json(200, {"ok": True, "navigation": self.course_navigation(course_id)})
            return

        if route == "/api/videos":
            course_id = self.course_id_from_query(parsed)
            self.send_json(200, {"ok": True, "videos": self.video_resources(course_id)})
            return
        if route == "/api/courses":
            query = parse_qs(parsed.query).get("q", [""])[0].strip().lower()
            limit = min(100, max(1, self.int_query(parsed, "limit", 24)))
            page = max(1, self.int_query(parsed, "page", 1))
            courses = self.load_courses()
            if query:
                courses = [c for c in courses if query in str(c.get("id", "")).lower() or query in str(c.get("title", "")).lower() or query in str(c.get("topic_focus", "")).lower()]
            filtered_total = len(courses)
            page_count = max(1, (filtered_total + limit - 1) // limit)
            page = min(page, page_count)
            start = (page - 1) * limit
            page_courses = courses[start:start + limit]
            state_path = self.memory_root / "当前状态.json"
            try:
                state = json.loads(state_path.read_text(encoding="utf-8"))
            except (OSError, json.JSONDecodeError):
                state = {}
            current_id = state.get("current_position", {}).get("course_id", "PRE0")
            self.send_json(200, {"ok": True, "total": len(self.load_courses()), "filtered_total": filtered_total, "page": page, "page_size": limit, "page_count": page_count, "current_course_id": current_id, "courses": [{"id": c.get("id"), "title": c.get("title"), "topic_focus": c.get("topic_focus"), "learner_status": c.get("learner_status", "not_started")} for c in page_courses]})
            return
        if route == "/api/report":
            try:
                start = int(parse_qs(parsed.query).get("start", ["1"])[0])
                end = int(parse_qs(parsed.query).get("end", [str(start + 9)])[0])
                self.send_json(200, {"ok": True, "report": self.report_for(start, end)})
            except (ValueError, OSError, json.JSONDecodeError):
                self.send_json(400, {"ok": False, "message": "十课报告参数无效"})
            return
        if route == "/api/questions":
            questions_path = self.memory_root / "课堂记录" / "助教问题.jsonl"
            self.send_json(200, {"ok": True, "questions": self.read_tail(questions_path, 50)})
            return
        if route == "/api/review":
            queue_path = self.memory_root / "复习队列.json"
            payload = self.load_json_file(queue_path, {"schema_version": "review-queue-v1", "policy": {"spacing_days": [1, 3, 7, 14, 30, 60]}, "items": []})
            today = datetime.now().astimezone().date().isoformat()
            items = payload.get("items", [])
            due = [item for item in items if item.get("status") == "queued" and str(item.get("due", today)) <= today]
            self.send_json(200, {"ok": True, "target_words": 20000, "items": due[:100], "queued_total": len(items), "due_total": len(due), "updated_at": payload.get("updated_at")})
            return
        if route == "/api/english-curriculum":
            self.send_json(200, {"ok": True, "curriculum": self.english_curriculum()})
            return
        if route == "/api/english-vocabulary":
            query = parse_qs(parsed.query).get("q", [""])[0].strip().lower()
            limit = min(200, max(1, self.int_query(parsed, "limit", 40)))
            page = max(1, self.int_query(parsed, "page", 1))
            vocab_path = self.classroom_root / "英语词汇库_高频.txt"
            try:
                words = [line.strip().lower() for line in vocab_path.read_text(encoding="utf-8").splitlines() if line.strip().isalpha()]
            except OSError:
                words = []
            if query:
                words = [word for word in words if query in word]
            total = len(words)
            page_count = max(1, (total + limit - 1) // limit)
            page = min(page, page_count)
            start = (page - 1) * limit
            self.send_json(200, {"ok": True, "target_words": 20000, "source": "英语词汇库_高频.txt", "total": total, "page": page, "page_size": limit, "page_count": page_count, "words": words[start:start + limit]})
            return
        if route == "/api/audit":
            courses = self.load_courses()
            contract_ids = {str(item.get("Id")) for item in self.load_contracts()}
            grammar_payload = self.grammar_plan()
            grammar_lessons = {str(item.get("course_id")): item for item in grammar_payload.get("lessons", []) if isinstance(item, dict)}
            pronunciation_items = self.pronunciation_asset().get("items", {})
            pronunciation_keys = {str(key).lower() for key in pronunciation_items} if isinstance(pronunciation_items, dict) else set()
            vocabulary_lessons = {str(item.get("course_id")): item for item in self.vocabulary_plan().get("lessons", []) if isinstance(item, dict)}
            report = {"courses_total": len(courses), "contract_total": len(contract_ids), "english_total": 0, "grammar_total": len(grammar_lessons), "pronunciation_total": len(pronunciation_keys), "missing_contract": [], "missing_english": [], "missing_grammar": [], "missing_pronunciation": [], "checked_at": datetime.now().astimezone().isoformat(timespec="seconds")}
            for item in courses:
                cid = str(item.get("id"))
                if cid not in contract_ids:
                    report["missing_contract"].append(cid)
                try:
                    english_path = self.classroom_root / f"{cid}-英语.json"
                    if english_path.exists():
                        lesson = self.normalize_english_lesson(cid, json.loads(english_path.read_text(encoding="utf-8")))
                        if not lesson.get("stage") or len(lesson.get("words", [])) < 3 or not lesson.get("grammar") or len(lesson.get("exercises", [])) < 6 or lesson.get("legacy_paper_routine"):
                            report["missing_english"].append(cid)
                    else:
                        generated = self.generated_english_lesson(cid)
                        if not generated.get("stage") or len(generated.get("words", [])) < 3 or not generated.get("grammar") or len(generated.get("exercises", [])) < 6 or generated.get("legacy_paper_routine"):
                            report["missing_english"].append(cid)
                    report["english_total"] += 1
                except (OSError, json.JSONDecodeError, KeyError, TypeError):
                    report["missing_english"].append(cid)
                if cid not in grammar_lessons:
                    report["missing_grammar"].append(cid)
                planned = vocabulary_lessons.get(cid, {}).get("new_words", [])
                if any(str(word).lower() not in pronunciation_keys for word in planned):
                    report["missing_pronunciation"].append(cid)
            report["ok"] = not report["missing_contract"] and not report["missing_english"] and not report["missing_grammar"] and not report["missing_pronunciation"] and report["courses_total"] == 590 and report["contract_total"] == 590 and report["english_total"] == 590 and report["grammar_total"] == 590 and report["pronunciation_total"] >= 20000
            self.send_json(200, report)
            return
        if route == "/api/english":
            course_id = self.course_id_from_query(parsed)
            self.load_courses()
            english_path = self.classroom_root / f"{course_id}-英语.json"
            try:
                lesson = json.loads(english_path.read_text(encoding="utf-8"))
                self.send_json(200, {"ok": True, "lesson": self.normalize_english_lesson(course_id, lesson)})
            except (OSError, json.JSONDecodeError):
                self.send_json(200, {"ok": True, "lesson": self.generated_english_lesson(course_id), "generated": True})
            return
        if route == "/api/history":
            course_id = self.course_id_from_query(parsed)
            answer_path = self.memory_root / "课堂记录" / "课堂回答" / f"{course_id}.jsonl"
            english_path = self.memory_root / "课堂记录" / "英语练习" / f"{course_id}.jsonl"
            module_path = self.memory_root / "课堂记录" / "模块回答" / f"{course_id}.jsonl"
            defense_path = self.memory_root / "课堂记录" / "答辩" / f"{course_id}.jsonl"

            gate_path = self.memory_root / "课堂记录" / "关卡验收" / f"{course_id}.jsonl"
            lab_path = self.memory_root / "课堂记录" / "Lab验收" / f"{course_id}.jsonl"
            self.send_json(200, {"ok": True, "course_id": course_id, "answers": self.read_tail(answer_path), "english": self.read_tail(english_path), "modules": self.read_tail(module_path, 200), "defense": self.read_tail(defense_path, 200), "gates": self.read_tail(gate_path), "labs": self.read_tail(lab_path)})
            return
        super().do_GET()

    def do_POST(self) -> None:
        route = urlparse(self.path).path
        if route not in ("/api/answer", "/api/english", "/api/module-answer", "/api/question", "/api/defense", "/api/gate", "/api/lab", "/api/review"):
            self.send_json(404, {"ok": False, "message": "未知接口"})
            return
        try:
            length = int(self.headers.get("Content-Length", "0"))
            if length <= 0 or length > 16_384:
                raise ValueError("答案长度无效")
            payload = json.loads(self.rfile.read(length).decode("utf-8"))
            answer = str(payload.get("answer", "")).strip()
            if not answer:
                raise ValueError("请先说出或写下一句自己的预测")
            if len(answer) > 4_000:
                raise ValueError("答案太长，请先用几句话表达核心预测")
            if route == "/api/review":
                item_id = str(payload.get("item_id", ""))[:120]
                try:
                    quality = max(0, min(5, int(payload.get("quality", 0))))
                except (TypeError, ValueError):
                    quality = 0
                queue_path = self.memory_root / "复习队列.json"
                review_payload = self.load_json_file(queue_path, {"schema_version": "review-queue-v1", "policy": {"spacing_days": [1, 3, 7, 14, 30, 60]}, "items": []})
                item = next((candidate for candidate in review_payload.get("items", []) if candidate.get("id") == item_id), None)
                if item is None:
                    raise ValueError("找不到这个复习条目")
                spacing = review_payload.get("policy", {}).get("spacing_days", [1, 3, 7, 14, 30, 60])
                index = min(len(spacing) - 1, max(0, quality - 1))
                if quality < 3:
                    item["status"] = "queued"
                    item["due"] = datetime.now().astimezone().date().isoformat()
                else:
                    item["status"] = "queued"
                    item["due"] = (datetime.now().astimezone() + __import__("datetime").timedelta(days=int(spacing[index]))).date().isoformat()
                item["last_quality"] = quality
                item["last_reviewed"] = datetime.now().astimezone().isoformat(timespec="seconds")
                review_payload["updated_at"] = datetime.now().astimezone().isoformat(timespec="seconds")
                self.save_json_file(queue_path, review_payload)
                self.send_json(200, {"ok": True, "message": "复习结果已保存，下一次复习日期：" + item["due"], "item": item})
                return
            if route in ("/api/gate", "/api/lab"):
                course_id = self.safe_course_id(payload.get("course_id", "PRE0"))
                item_id = str(payload.get("item_id", ""))[:40]
                evidence = str(payload.get("evidence", answer))[:4_000].strip()
                if not item_id:
                    raise ValueError("缺少关卡或 Lab 编号")
                words = [word for word in evidence.lower().replace("，", " ").replace("。", " ").split() if word]
                has_observation = any(term in evidence.lower() for term in ("输出", "观察", "结果", "output", "evidence", "证据"))
                has_explanation = len(evidence) >= 30
                auto_score = 0
                auto_notes = []
                if has_explanation:
                    auto_score += 50
                else:
                    auto_notes.append("证据说明至少写 30 个字符，包含你观察到的现象。")
                if has_observation:
                    auto_score += 30
                else:
                    auto_notes.append("补充原始输出、截图说明或可复现的观察结果。")
                if payload.get("command") or payload.get("artifact"):
                    auto_score += 20
                else:
                    auto_notes.append("补充命令/测试、退出码或制品路径，老师才能复核。")
                record = {
                    "timestamp": datetime.now().astimezone().isoformat(timespec="seconds"),
                    "course_id": course_id,
                    "item_id": item_id,
                    "kind": "gate" if route == "/api/gate" else "lab",
                    "answer": answer,
                    "evidence": evidence,
                    "command": str(payload.get("command", ""))[:2_000],
                    "artifact": str(payload.get("artifact", ""))[:500],
                    "auto_screen": {"score": auto_score, "notes": auto_notes},
                    "teacher_review": "pending",
                    "changes_mastery_state": False,
                }
                folder = "关卡验收" if route == "/api/gate" else "Lab验收"
                target = self.memory_root / "课堂记录" / folder / f"{course_id}.jsonl"
                self.append_jsonl(target, record)
                message = "已保存并完成自动预审（{} 分）。".format(auto_score)
                if auto_notes:
                    message += " " + " ".join(auto_notes)
                else:
                    message += " 证据完整度较好，等待老师人工验收；不会自动升级掌握状态。"
                self.update_current_position(course_id, f"{item_id} 证据已提交，等待老师人工验收；自动预审 {auto_score} 分。", "Lv1")
                self.send_json(200, {"ok": True, "message": message, "auto_screen": record["auto_screen"], "review": "pending"})
                return
            if route == "/api/question":
                course_id = self.safe_course_id(payload.get("course_id", "PRE0"))
                record = {
                    "timestamp": datetime.now().astimezone().isoformat(timespec="seconds"),
                    "course_id": course_id,
                    "question": answer,
                    "source": "learner-assistant-inbox",
                    "teacher_review": "pending",
                    "answered": False,
                }
                target = self.memory_root / "课堂记录" / "助教问题.jsonl"
                self.append_jsonl(target, record)
                self.send_json(200, {"ok": True, "message": "问题已保存到助教收件箱，下一次课堂会从这里接着回答。", "review": "pending"})
                return
            if route == "/api/defense":
                course_id = self.safe_course_id(payload.get("course_id", "PRE0"))
                defense_id = str(payload.get("defense_id", ""))[:80]
                if not defense_id:
                    raise ValueError("缺少答辩题编号")
                question = str(payload.get("question", ""))[:2_000]
                defense_index = max(1, min(99, int(payload.get("defense_index", 1))))
                target = self.memory_root / "课堂记录" / "答辩" / f"{course_id}.jsonl"
                existing = next((item for item in self.read_tail(target, 2_000) if item.get("defense_id") == defense_id), None)
                if existing:
                    self.send_json(200, {"ok": True, "locked": True, "message": "这道答辩题已经提交过，原答案已永久锁定。", "record": existing})
                    return
                record = {
                    "timestamp": datetime.now().astimezone().isoformat(timespec="seconds"),
                    "course_id": course_id,
                    "defense_id": defense_id,
                    "defense_index": defense_index,
                    "question": question,
                    "answer": answer[:4_000],
                    "teacher_review": "pending",
                    "changes_mastery_state": False,
                    "source": "oral-defense-classroom",
                }
                self.append_jsonl(target, record)
                self.update_current_position(course_id, f"答辩题 {defense_index} 已提交并锁定，等待老师批改。", f"defense-{defense_index:02d}")
                self.send_json(200, {"ok": True, "locked": True, "message": "答辩答案已永久保存并锁定；可以用上一题回看。", "saved_to": str(target.relative_to(self.memory_root)), "record": record})
                return
            if route == "/api/english":
                exercise_type = str(payload.get("exercise_type", "general"))[:80]
                expected = str(payload.get("expected", ""))[:500]
                course_id = self.safe_course_id(payload.get("course_id", "PRE0"))
                review_mode = str(payload.get("review_mode", "")) == "teacher" or exercise_type in {"short_writing", "reading_summary", "academic_paragraph", "translation_zh_en", "translation_en_zh", "sentence_transform"}
                correct, error_type = self.classify_english(answer, expected)
                if review_mode and exercise_type in {"short_writing", "reading_summary", "academic_paragraph", "sentence_transform"}:
                    correct, error_type = False, "teacher_review"
                history_path = self.memory_root / "课堂记录" / "英语练习" / f"{course_id}.jsonl"
                attempt = len(self.read_tail(history_path, 10000)) + 1
                record = {
                    "timestamp": datetime.now().astimezone().isoformat(timespec="seconds"),
                    "course_id": course_id,
                    "exercise_id": str(payload.get("exercise_id", "PRE0-ENGLISH")),
                    "exercise_type": exercise_type,
                    "answer": answer,
                    "expected": expected,
                    "correct": correct,
                    "error_type": error_type,
                    "strand": str(payload.get("strand", exercise_type))[:80],
                    "stage": str(payload.get("stage", ""))[:40],
                    "attempt": attempt,
                    "review_mode": "teacher" if review_mode else "exact_or_heuristic",
                    "hint_used": bool(payload.get("hint_used", False)),
                    "source": "unified-classroom",
                    "teacher_review": "pending",
                    "changes_mastery_state": False,
                }
                practice_dir = self.memory_root / "课堂记录" / "英语练习"
                practice_dir.mkdir(parents=True, exist_ok=True)
                target = practice_dir / f"{course_id}.jsonl"
                self.append_jsonl(target, record)
                self.queue_english_review(record, correct, error_type)
                if review_mode:
                    feedback = "答案已保存到老师批改队列。先保留你的原文；老师会按词汇、语法、语序、连贯性和学术语域逐项反馈。"
                elif correct:
                    feedback = "这次答案与目标一致。已安排间隔复习，仍需老师验收后才计入掌握。"
                else:
                    labels = {"spelling": "拼写", "word_order": "语序", "grammar": "语法", "meaning_or_recall": "词义/回忆", "teacher_review": "开放题待批改"}
                    feedback = "答案已保存。当前最需要复习：" + labels.get(error_type, "词义/回忆") + "。请按目标句重写一遍。"
                self.update_current_position(course_id, "继续完成本节英语训练；复习队列已记录 " + error_type, "Lv1")
                self.send_json(200, {"ok": True, "message": feedback, "review": "pending", "correct": correct, "error_type": error_type, "saved_to": str(target.relative_to(self.memory_root))})
                return
            if route == "/api/module-answer":
                course_id = self.safe_course_id(payload.get("course_id", "PRE0"))
                module_id = str(payload.get("module_id", "module-01"))[:80]
                module_index = max(1, min(99, int(payload.get("module_index", 1))))
                language = str(payload.get("language", "zh"))[:10]
                rubric_terms = payload.get("rubric_terms", [])
                if not isinstance(rubric_terms, list):
                    rubric_terms = []
                score, notes = self.screen_module(answer, rubric_terms)
                if language.lower().startswith("en"):
                    if not any(ch.isalpha() for ch in answer):
                        notes.append("英语回答请至少包含英文单词。")
                        score = max(0, score - 20)
                    if not any(mark in answer for mark in (" ", ".", "?", "!")):
                        notes.append("试着写成一个完整短句，并在句末加标点。")
                        score = max(0, score - 10)
                record = {
                    "timestamp": datetime.now().astimezone().isoformat(timespec="seconds"),
                    "course_id": course_id,
                    "module_id": module_id,
                    "module_index": module_index,
                    "language": language,
                    "answer": answer[:4_000],
                    "rubric_terms": [str(term)[:80] for term in rubric_terms[:8]],
                    "auto_screen": {"score": score, "notes": notes},
                    "teacher_review": "pending",
                    "changes_mastery_state": False,
                    "source": "integrated-module-classroom",
                }
                target = self.memory_root / "课堂记录" / "模块回答" / f"{course_id}.jsonl"
                self.append_jsonl(target, record)
                if language.lower().startswith("en"):
                    self.queue_english_review({"course_id": course_id, "exercise_id": f"{course_id}-{module_id}-EN", "answer": answer}, score >= 80 and not notes, "module_english" if notes else "none")
                self.update_current_position(course_id, f"模块 {module_index} 已提交；继续完成本模块英语与计算机练习。", f"module-{module_index:02d}")
                if score >= 80 and not notes:
                    message = "模块回答已保存，自动预审通过（{} 分）；仍等待老师逐句验收。".format(score)
                else:
                    message = "模块回答已保存，自动预审 {} 分。{}".format(score, " ".join(notes))
                self.send_json(200, {"ok": True, "message": message, "auto_screen": record["auto_screen"], "review": "pending", "saved_to": str(target.relative_to(self.memory_root))})
                return
            record = {
                "timestamp": datetime.now().astimezone().isoformat(timespec="seconds"),
                "course_id": self.safe_course_id(payload.get("course_id", "PRE0")),
                "question_id": str(payload.get("question_id", "PRE0-PREDICT-INPUT-PROCESS-OUTPUT")),
                "answer": answer,
                "source": "unified-classroom",
                "teacher_review": "pending",
                "changes_mastery_state": False,
            }
            concept_score, missing = self.screen_concept(answer)
            record["auto_screen"] = {"score": concept_score, "missing": missing}
            answers_dir = self.memory_root / "课堂记录" / "课堂回答"
            answers_dir.mkdir(parents=True, exist_ok=True)
            target = answers_dir / f"{record['course_id']}.jsonl"
            self.append_jsonl(target, record)

            if missing:
                feedback = "答案已保存。你已经开始建立模型；再补充说明：" + "、".join(missing) + " 分别是什么。"
            else:
                feedback = "答案已保存。你已经覆盖 input、process 和 output。继续课堂后，我们会检查三者之间的因果链。"
            language_coaching = "英文可以这样写：Input: I type the letter A on the keyboard. Process: The computer processes the input. Output: The letter A appears on the screen."
            self.update_current_position(record["course_id"], "概念回答已保存；完成本节英语词汇/拼写/语序/短写作，再执行 Lab 1。", "Lv1")
            self.send_json(200, {"ok": True, "message": feedback, "language_coaching": language_coaching, "auto_screen": record["auto_screen"], "saved_to": f"学习者记忆库/课堂记录/课堂回答/{record['course_id']}.jsonl", "review": "pending"})
        except (ValueError, json.JSONDecodeError) as exc:
            self.send_json(400, {"ok": False, "message": str(exc)})
        except Exception:
            self.send_json(500, {"ok": False, "message": "保存答案时出现本地错误，请保留当前文字并稍后重试"})


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--port", type=int, default=8765)
    parser.add_argument("--root", type=Path, required=True)
    args = parser.parse_args()
    root = args.root.resolve()
    ClassroomHandler.classroom_root = root
    ClassroomHandler.memory_root = root.parent
    handler = lambda *handler_args, **kwargs: ClassroomHandler(  # noqa: E731
        *handler_args, directory=str(root), **kwargs
    )
    server = ThreadingHTTPServer(("127.0.0.1", args.port), handler)
    print(f"Classroom: http://127.0.0.1:{args.port}/课堂模式.html", flush=True)
    server.serve_forever()


if __name__ == "__main__":
    main()
