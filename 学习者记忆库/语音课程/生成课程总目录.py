"""Generate a self-contained, searchable HTML catalog for all 590 lessons."""

from __future__ import annotations

import html
import json
from pathlib import Path


ROOT = Path(__file__).resolve().parent
MEMORY = ROOT.parent
COURSE_ROOT = MEMORY.parent
MATRIX_PATH = MEMORY / "掌握矩阵.json"
CONTRACT_PATH = COURSE_ROOT / "逐课专属深度合同_590课.json"
OUT = ROOT / "课程总目录_590节.html"


def esc(value: object) -> str:
    return html.escape(str(value or ""), quote=True)


def load_json(path: Path, default):
    try:
        return json.loads(path.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError):
        return default


def build() -> str:
    matrix = load_json(MATRIX_PATH, [])
    courses = matrix if isinstance(matrix, list) else matrix.get("courses", [])
    contracts_payload = load_json(CONTRACT_PATH, [])
    contracts = contracts_payload if isinstance(contracts_payload, list) else contracts_payload.get("courses", [])
    by_id = {str(item.get("Id")): item for item in contracts}
    cards = []
    for index, course in enumerate(courses, 1):
        cid = str(course.get("id", ""))
        contract = by_id.get(cid, {})
        levels = contract.get("Levels", [])[:5]
        labs = contract.get("Labs", [])[:5]
        checkpoints = contract.get("Checkpoints", [])[:5]
        level_html = "".join(f"<li><b>Lv{i + 1}</b> {esc(level)}</li>" for i, level in enumerate(levels))
        lab_html = "".join(
            f"<li><b>{esc(lab.get('Name', f'Lab {i + 1}'))}</b><br>输入：{esc(lab.get('Input'))}<br>预期：{esc(lab.get('Expected'))}<br>失败：{esc(lab.get('Failure'))}<br>证据：{esc(lab.get('Evidence'))}</li>"
            for i, lab in enumerate(labs)
        )
        checkpoint_html = "".join(
            f"<li><b>{esc(item.get('Stage'))}</b><br>题目：{esc(item.get('Prompt'))}<br>交付：{esc(item.get('Deliverable'))}<br>通过条件：{esc(item.get('Gate'))}</li>"
            for item in checkpoints
        )
        cards.append(
            f"""<details class=course data-id="{esc(cid)}" data-search="{esc(' '.join(str(course.get(key, '')) for key in ('id', 'title', 'topic_focus', 'category'))).lower()}">
<summary><span class=course-number>{index:03d}</span><strong>{esc(cid)}</strong><span>{esc(course.get('title'))}</span></summary>
<div class=course-body><div class=actions><a href="课堂模式.html?course_id={esc(cid)}">进入双语课堂 ▶</a><a href="英语学习中心.html?course_id={esc(cid)}">进入英语学习中心 ↗</a><span>证据目录：{esc(course.get('evidence_path'))}</span><span>类别：{esc(course.get('category'))}</span></div>
<div class=facts><p><b>主题：</b>{esc(course.get('topic_focus'))}</p><p><b>前置：</b>{esc(course.get('prerequisites'))}</p><p><b>机制：</b>{esc(contract.get('Mechanism'))}</p><p><b>不变量：</b>{esc(contract.get('Invariant'))}</p><p><b>指标：</b>{esc(contract.get('Metric'))}</p><p><b>失败实验：</b>{esc(contract.get('Failure'))}</p><p><b>复杂度出口：</b>{esc(contract.get('Complexity'))}</p><p><b>研究问题：</b>{esc(contract.get('ResearchQuestion'))}</p><p><b>资料：</b><a href="{esc(contract.get('Url'))}" target=_blank rel=noopener>{esc(contract.get('Source'))}</a><br>{esc(contract.get('SourceChapter'))}</p></div>
<div class=columns><section><h3>Lv1–Lv5</h3><ol>{level_html}</ol></section><section><h3>5 个 Lab</h3><ol>{lab_html}</ol></section></div><section><h3>5 个检查点</h3><ol>{checkpoint_html}</ol></section></div></details>"""
        )
    html = f"""<!doctype html><html lang=zh-CN><head><meta charset=utf-8><meta name=viewport content=width=device-width,initial-scale=1><title>全领域宗师级课程目录 · 590 节</title><style>
:root{{--ink:#20262e;--muted:#697382;--line:#dce2e8;--paper:#fff;--soft:#f4f6f8;--blue:#1f5f9e}}*{{box-sizing:border-box}}body{{margin:0;background:#eef1f4;color:var(--ink);font-family:"Segoe UI","Microsoft YaHei",sans-serif}}main{{max-width:1280px;margin:0 auto;padding:28px 18px 60px}}h1{{margin:0 0 8px;font-size:clamp(25px,4vw,42px)}}h2{{margin:24px 0 10px;font-size:20px}}h3{{margin:16px 0 8px;font-size:15px;color:var(--blue)}}p{{line-height:1.6}}.lede,.meta{{color:var(--muted);line-height:1.6}}.toolbar{{position:sticky;top:0;z-index:2;display:flex;gap:9px;flex-wrap:wrap;padding:12px 0;background:#eef1f4}}input{{flex:1 1 320px;min-height:42px;padding:0 12px;border:1px solid var(--line);border-radius:6px;font:inherit}}button{{min-height:42px;padding:0 14px;border:1px solid #cbd4de;border-radius:6px;background:#fff;font:inherit;cursor:pointer}}.status{{color:var(--muted);font-size:13px;align-self:center}}.course{{margin:9px 0;background:var(--paper);border:1px solid var(--line);border-radius:7px;overflow:hidden}}summary{{display:flex;align-items:center;gap:10px;padding:13px;cursor:pointer;list-style:none}}summary::-webkit-details-marker{{display:none}}summary:hover{{background:#f7fafc}}summary strong{{color:var(--blue);min-width:52px}}summary span:last-child{{color:var(--ink);line-height:1.45}}.course-number{{color:var(--muted);font-size:12px;min-width:28px}}.course-body{{padding:0 14px 16px;border-top:1px solid var(--line)}}.actions{{display:flex;gap:12px;flex-wrap:wrap;padding:11px 0;color:var(--muted);font-size:12px}}a{{color:var(--blue)}}.facts{{display:grid;grid-template-columns:repeat(2,minmax(0,1fr));gap:8px}}.facts p{{margin:0;padding:9px;background:var(--soft);font-size:13px;line-height:1.5}}.columns{{display:grid;grid-template-columns:1fr 1fr;gap:16px}}ol{{margin:0;padding-left:23px}}li{{margin:6px 0;font-size:13px;line-height:1.55}}@media(max-width:700px){{main{{padding:20px 12px 40px}}.facts,.columns{{grid-template-columns:1fr}}summary{{align-items:flex-start;flex-wrap:wrap}}}}
</style></head><body><main><div class=meta>Computer Science · Mastery Path</div><h1>全领域宗师级课程目录 · 590 节</h1><p class=lede>这是完整可搜索目录。每一项都能进入对应双语课堂，并展开查看本课的深度合同、五级闯关、五个 Lab、检查点和资料锚点。页面中的课程资产不等于学习者已掌握，真实状态仍以证据和老师验收为准。</p><p class=meta>课程：{len(courses)} · 深度合同：{len(by_id)} · 每课：11 段讲授 + 5 级闯关 + 5 个 Lab + 5 个检查点</p><div class=toolbar><input id=search placeholder="搜索课号、标题、主题或类别"><button id=expand>展开当前结果</button><button id=collapse>全部收起</button><span class=status id=status>正在显示 {len(courses)} 节</span></div><section id=list>{''.join(cards)}</section></main><script>const input=document.querySelector('#search'),items=[...document.querySelectorAll('.course')],status=document.querySelector('#status');function filter(){{const q=input.value.trim().toLowerCase();let n=0;items.forEach(x=>{{const ok=!q||x.dataset.search.includes(q);x.hidden=!ok;if(ok)n++}});status.textContent='匹配 '+n+' / {len(courses)} 节'}}input.addEventListener('input',filter);document.querySelector('#expand').onclick=()=>items.filter(x=>!x.hidden).forEach(x=>x.open=true);document.querySelector('#collapse').onclick=()=>items.forEach(x=>x.open=false);</script></body></html>"""

    html = html.replace(
        '<div class=meta>Computer Science · Mastery Path</div>',
        '<div class=meta><a href="学习主页.html">← 返回学习主页</a> · Computer Science · Mastery Path</div>',
        1,
    )
    html = html.replace(
        '<div class=toolbar><input id=search',
        '<div class=toolbar><a href="学习主页.html">主页</a><a href="英语学习中心.html">英语中心</a><input id=search',
        1,
    )
    return html


if __name__ == "__main__":
    OUT.write_text(build(), encoding="utf-8")
    print(f"wrote {OUT} ({OUT.stat().st_size} bytes)")
