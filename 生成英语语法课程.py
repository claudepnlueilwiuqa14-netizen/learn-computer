"""Build the auditable 590-lesson English grammar route.

The route is intentionally explicit: a stage description alone is not enough
for a beginner.  Every lesson receives one primary grammar topic, spaced
review topics, a plain-language explanation, a model sentence, a contrastive
warning, and a mastery check.  The scope is core A0-C2+ English plus research
writing grammar; rare dialect-specific constructions remain outside the
beginner route and are named in the coverage note.
"""

from __future__ import annotations

import json
from pathlib import Path


ROOT = Path(__file__).resolve().parent
MEMORY = ROOT / "学习者记忆库"
COURSE_ROOT = MEMORY / "语音课程"
OUT = COURSE_ROOT / "英语语法课程_590课.json"


TOPICS: list[dict] = []


def add(
    ident: str,
    stage: str,
    title: str,
    pattern: str,
    explanation: str,
    example: str,
    translation: str,
    contrast: str,
    task: str,
    strand: str = "core",
) -> None:
    TOPICS.append(
        {
            "id": ident,
            "stage": stage,
            "title": title,
            "pattern": pattern,
            "explanation": explanation,
            "example": example,
            "translation": translation,
            "contrast": contrast,
            "task": task,
            "strand": strand,
            "mastery": f"能解释 {title} 的结构，正确改写一个计算机例句，并指出一个容易出错的边界。",
        }
    )


# A0: letters, words, the smallest safe sentences and questions.
for row in [
    ("a01", "字母、大小写与句末标点", "Capital letter + words + period", "先识别字母、单词边界、空格和句号；术语可以后学。", "A computer starts.", "电脑启动。", "不要把每个字母当成一个单词。", "把一句电脑动作正确输入两遍，并圈出第一个大写字母。"),
    ("a02", "主语代词", "I / you / he / she / it / we / they + verb", "主语告诉我们是谁在做事；英语动词前通常必须有主语。", "I study.", "我学习。", "中文常省略主语，英语短句通常不能省略。", "用七个主语各写一个最短句。"),
    ("a03", "be 动词 am/is/are", "I am; he/she/it is; you/we/they are", "be 可以表示‘是’或‘在’，要跟着主语变化。", "The file is here.", "文件在这里。", "不能把 I 和 is、they 和 is 随意搭配。", "把三句 be 句分别换成 I、it、they。"),
    ("a04", "be 的缩写", "I am → I'm; it is → it's", "口语和非正式课堂里常用缩写；正式论文中要按语域选择。", "It's a file.", "这是一个文件。", "it's 是 it is；its 是它的，不能混写。", "把四个完整句与缩写句配对。"),
    ("a05", "不定冠词 a", "a + singular count noun", "第一次提到一个可数单数物体时常用 a。", "This is a file.", "这是一个文件。", "a 不能直接放在复数或不可数名词前。", "用 a + 三个电脑名词造句。"),
    ("a06", "不定冠词 an", "an + vowel sound", "an 看的是开头音，不只是字母；元音音素前用 an。", "This is an input.", "这是一个输入。", "hour 是 an hour，但 university 是 a university。", "从本课词汇中找两个 a、两个 an 的例子。"),
    ("a07", "定冠词 the", "the + known/specific noun", "双方知道或已经提到的对象常用 the。", "The file is open.", "这个文件是打开的。", "第一次泛指和特指不要混淆。", "把一个泛指句改成特指句。"),
    ("a08", "this/that/these/those", "demonstrative + noun", "指近处、远处、单数和复数；this/that 配单数。", "These files are new.", "这些文件是新的。", "these 不能和单数名词搭配。", "用近处和远处各写一个单数、复数句。"),
    ("a09", "名词复数规则", "noun + -s/-es", "多数可数名词复数加 -s，部分词加 -es 或改变拼写。", "Two files are open.", "两个文件是打开的。", "复数名词通常不能再用 a/an。", "把五个单数电脑词变成复数并造句。"),
    ("a10", "there is/there are", "There is + singular; there are + plural", "用 there is/are 表达‘有’；真正的数量决定 be。", "There are two files.", "有两个文件。", "不要只看 there 决定 is/are。", "把一个存在句改成复数，再改回单数。"),
    ("a11", "物主限定词", "my/your/his/her/its/our/their + noun", "物主词放在名词前说明归属。", "My computer is ready.", "我的电脑准备好了。", "my 后面要有名词，不能单独当代词。", "用七个物主词写七个短语。"),
    ("a12", "物主代词", "mine/yours/his/hers/ours/theirs", "物主代词可以独立使用，后面不再接名词。", "This file is mine.", "这个文件是我的。", "my file 与 mine 的结构不同。", "把 three 个 my + noun 句改写为 mine 句。"),
    ("a13", "指令句", "base verb + object", "祈使句用动词原形给出安全、清楚的操作指令。", "Open the file.", "打开文件。", "不要给祈使句加主语 he/she。", "写三个可撤销的课堂操作指令。"),
    ("a14", "can 能力", "subject + can + base verb", "can 后面用动词原形，表示能力或许可。", "I can read the file.", "我会读这个文件。", "不能写 can reads 或 can to read。", "把两个不会的句子改成 can 句。"),
    ("a15", "have/has", "I/you/we/they have; he/she/it has", "have 表拥有或包含，第三人称单数用 has。", "The program has an error.", "程序有一个错误。", "主语变化时 has 不能漏掉。", "用 have 和 has 各写两句。"),
    ("a16", "基本介词地点", "in/on/at + place", "介词说明对象所在位置；先用真实桌面和窗口练习。", "The file is in the folder.", "文件在文件夹里。", "in、on、at 的空间范围不同。", "画三个位置关系并写句子。"),
    ("a17", "基本介词时间", "at/on/in + time", "at 用具体时刻，on 用日期，in 用月份、年份或较长时段。", "The test runs at nine.", "测试九点运行。", "不要把 at nine 写成 in nine。", "把一个实验安排写成三种时间短语。"),
    ("a18", "并列 and/but/or", "clause + coordinator + clause", "and 连接增加，but 表转折，or 表选择。", "The input is small but useful.", "输入很小但很有用。", "并列两边最好保持相近结构。", "用 and、but、or 各连接一次。"),
    ("a19", "一般疑问句与短答", "Be/Do/Can + subject ...?", "把 be、do 或 can 放到主语前形成最短问题。", "Can you open the file? Yes, I can.", "你能打开文件吗？能。", "be 问句和实义动词 do 问句的助动词不同。", "写三个问题并给出完整短答。"),
    ("a20", "特殊疑问词", "what/where/when/who/why/how + question", "疑问词决定你要寻找的信息类型。", "Where is the file?", "文件在哪里？", "what 问事物，where 问地点，不要混用。", "用六个疑问词各写一个电脑问题。"),
]:
    add(row[0], "A0", *row[1:])


# A1/A2: tense, aspect, quantity, modality, clauses and everyday technical prose.
for row in [
    ("a21", "一般现在时", "subject + base verb", "表达习惯、事实和稳定的程序行为。", "A computer follows instructions.", "电脑遵循指令。", "事实不是过去时；时间副词也要匹配。", "写三个稳定的计算机事实。"),
    ("a22", "第三人称单数", "he/she/it + verb-s", "一般现在时中第三人称单数动词通常加 -s/-es。", "The program runs.", "程序运行。", "有 does 时实义动词回到原形。", "把 I run 改写成 the program runs，再改成疑问句。"),
    ("a23", "频率副词", "usually/often/rarely + verb", "频率副词帮助说明习惯强度和复现规律。", "The test usually passes.", "测试通常通过。", "be 动词与实义动词的位置不同。", "给一个测试写 always、usually、rarely 三句。"),
    ("a24", "现在进行时", "be + verb-ing", "表示此刻或当前阶段正在进行的动作。", "The system is running.", "系统正在运行。", "状态动词通常不随意用进行时。", "描述当前电脑屏幕上的三个动作。"),
    ("a25", "状态动词", "know/need/own + simple form", "know、need、own 等状态常用一般现在时。", "We need evidence.", "我们需要证据。", "不要机械地把所有动词改成 -ing。", "把五个动作词和状态词分类。"),
    ("a26", "过去 be", "was/were", "描述过去的状态、位置和条件。", "The file was empty.", "文件当时是空的。", "I/he 用 was，you/we/they 用 were。", "写实验开始前的两个状态。"),
    ("a27", "一般过去时规则动词", "verb-ed", "叙述已经完成的实验步骤和观察。", "We tested the input.", "我们测试了输入。", "did 出现后动词用原形。", "写三步过去时实验记录。"),
    ("a28", "一般过去时不规则动词", "go→went; write→wrote", "高频不规则动词需要通过句子和间隔复习掌握。", "The process began.", "处理开始了。", "不能给所有过去式机械加 -ed。", "从本课词汇写五个不规则过去句。"),
    ("a29", "过去进行时", "was/were + verb-ing", "描述过去某时正在进行的背景动作。", "The system was running when the test failed.", "测试失败时系统正在运行。", "主事件与背景事件的时态作用不同。", "把一个故障时间线写成背景+事件。"),
    ("a30", "will 将来", "will + base verb", "表示预测、即时决定或承诺。", "The next test will compare two inputs.", "下一次测试将比较两个输入。", "will 后面不能用过去式或 to。", "写一个可验证的下一步预测。"),
    ("a31", "be going to", "be going to + base verb", "表示已有计划或有迹象的预测。", "We are going to repeat the test.", "我们打算重复测试。", "计划和即时决定的语气不同。", "把一个计划和一个临时决定分别写出。"),
    ("a32", "现在进行时表将来", "be + verb-ing + future time", "已经安排的未来事项可用现在进行时。", "We are meeting the reviewer tomorrow.", "我们明天会见审阅者。", "要有明确的未来时间或安排语境。", "把一个课程安排写成进行时将来句。"),
    ("a33", "情态 can/could", "can/could + base verb", "can 表能力/许可，could 可表示过去能力或更委婉请求。", "Could you repeat the command?", "你能重复这条命令吗？", "情态动词后不用第三人称 -s。", "写一个能力句和一个礼貌请求。"),
    ("a34", "must/have to", "must/have to + base verb", "must 表说话者强要求，have to 常表示外部规则或事实需要。", "You must protect the data.", "你必须保护数据。", "过去时通常用 had to，不写 musted。", "把一条安全规则分别写成 must 和 have to。"),
    ("a35", "should/ought to", "should + base verb", "给出建议、预期和较弱义务。", "You should record the version.", "你应该记录版本。", "建议不是绝对命令；语气要匹配风险。", "写一条实验建议并说明为什么不是 must。"),
    ("a36", "may/might", "may/might + base verb", "表达可能性、许可和不确定推断。", "The error might be caused by the path.", "错误可能由路径造成。", "may/might 不是确定事实。", "给一个结论写强、中、弱三种可能性。"),
    ("a37", "比较级", "-er/more + adjective + than", "比较两个对象的属性、性能或风险。", "This method is faster than the old one.", "这个方法比旧方法快。", "短形容词和长形容词的形式不同。", "用三个指标比较两种方案。"),
    ("a38", "最高级", "the -est/most + adjective", "在明确范围中指出最高程度。", "This is the most reliable result.", "这是最可靠的结果。", "最高级通常需要 the 或明确范围。", "在三次实验中指出一个最高值。"),
    ("a39", "as...as 与倍数", "as + adjective + as; twice as...as", "表达相等、倍数和受控比较。", "The second run is twice as fast as the first.", "第二次运行是第一次的两倍快。", "倍数结构不能直接套比较级。", "用一个时间指标写 as...as 和 twice as...as。"),
    ("a40", "数量词", "many/much/few/little/a lot of", "可数与不可数名词需要不同数量表达。", "We have little evidence but many tests.", "我们证据很少但测试很多。", "evidence 通常不可数，tests 可数。", "把十个名词分可数/不可数并配数量词。"),
    ("a41", "宾语代词", "me/you/him/her/us/them", "动作的接受者使用宾语代词。", "The teacher helped me.", "老师帮助了我。", "主语代词和宾语代词位置不同。", "把五个名词宾语改写成代词。"),
    ("a42", "反身代词", "myself/yourself/itself...", "主语和宾语相同时使用反身代词，也可加强语气。", "The script checks itself.", "脚本检查自身。", "不能把反身代词当普通宾语随意使用。", "写一个系统自检句和一个强调句。"),
    ("a43", "动名词", "verb-ing as noun", "动名词把动作当作名词，可作主语或宾语。", "Testing improves reliability.", "测试能提高可靠性。", "动名词与现在分词形式相同但功能不同。", "把三个动作改成动名词主语。"),
    ("a44", "不定式", "to + base verb", "不定式可表达目的、计划和动词补语。", "We test to find the cause.", "我们测试是为了找到原因。", "情态动词后不用 to。", "用 to express purpose 写三句。"),
    ("a45", "动词搭配", "verb + gerund/infinitive", "不同动词选择动名词或不定式，意义可能变化。", "We avoided changing the input.", "我们避免改变输入。", "avoid to change 是常见错误。", "整理五个 verb+ing 和五个 verb+to 搭配。"),
    ("a46", "目的、结果与原因连接", "to/in order to; so...that; because", "连接词把单句扩成可解释的因果链。", "We logged the output to reproduce the error.", "我们记录输出以复现错误。", "目的和原因不是同一个逻辑关系。", "把一段操作说明改写成目的链。"),
    ("a47", "时间从句", "when/while/before/after + clause", "时间连接词组织实验步骤和事件顺序。", "When the test ends, save the log.", "测试结束后保存日志。", "从句时态要和主句时间关系一致。", "把四步时间线写成一个复合句。"),
    ("a48", "零条件句", "if + present, present", "表达稳定规律和可重复规则。", "If input is empty, the program returns an error.", "如果输入为空，程序返回错误。", "规律与一次性未来事件不要混为一谈。", "写一个可重复的程序规则。"),
    ("a49", "第一条件句", "if + present, will + verb", "表达未来可能发生的条件和结果。", "If the test passes, we will publish the result.", "如果测试通过，我们将发布结果。", "if 从句通常不用 will 表未来。", "写一个带停止条件的未来计划。"),
    ("a50", "被动语态入门", "be + past participle", "把受影响对象放到主语位置，突出过程或结果。", "The file is saved automatically.", "文件被自动保存。", "be 的时态和过去分词都不能漏。", "把三句主动操作改成被动。"),
    ("a51", "宾语从句", "verb + that-clause", "把一个完整命题放在 know、show、suggest 等动词后。", "The log shows that the path is valid.", "日志显示路径有效。", "that 可省略但从句主谓不能丢。", "把三个观察改成 that 从句。"),
    ("a52", "关系从句基础", "noun + who/which/that + clause", "用关系从句给对象增加限定信息。", "The file that we opened was empty.", "我们打开的文件是空的。", "关系代词所指的先行词要清楚。", "把两个短句合并成一个定义关系从句。"),
    ("a53", "非限定关系从句", "noun, which/who + clause,", "逗号中的补充信息不改变先行词范围。", "The log, which was local, contained no secret.", "日志是本地的，且不含秘密。", "非限定从句不能用 that。", "给一个技术对象加一条非限定信息。"),
    ("a54", "间接疑问句", "Could you tell me + wh-clause?", "把问题嵌入礼貌请求时使用陈述语序。", "Could you tell me where the file is?", "你能告诉我文件在哪里吗？", "间接疑问句不能倒装成 where is the file。", "把三个直接问题改成礼貌请求。"),
    ("a55", "直接引语与间接引语", "said that + backshift", "转述别人话语时处理人称、时态和指示词变化。", "She said that the test had failed.", "她说测试已经失败。", "转述不是逐字复制，时间参照点会改变。", "把一条课堂反馈改写成间接引语。"),
]:
    add(row[0], "A1" if int(row[0][1:]) <= 36 else "A2", *row[1:])


# B1/B2: complex clauses, aspect, reporting, cohesion and precise engineering prose.
for row in [
    ("b01", "现在完成时", "have/has + past participle", "把过去事件与现在结果、经验或持续时间连接起来。", "We have reproduced the error.", "我们已经复现了错误。", "明确过去时间通常更适合一般过去时。", "写一条已经完成且影响现在的实验结果。"),
    ("b02", "现在完成进行时", "have/has been + verb-ing", "强调从过去持续到现在的活动和过程。", "We have been testing the service for an hour.", "我们已经测试这个服务一小时了。", "结果重点与过程重点不同。", "把一个长时间实验写成完成进行时。"),
    ("b03", "过去完成时", "had + past participle", "表示过去某一时点之前已经完成的事件。", "The service had stopped before we checked the log.", "我们检查日志前服务已经停止。", "两个过去事件的先后需要清楚。", "用时间线写两个 had 句。"),
    ("b04", "过去完成进行时", "had been + verb-ing", "强调过去某一时点前持续的过程。", "The process had been running for ten minutes before it failed.", "进程失败前已经运行了十分钟。", "不要用它描述单次瞬间事件。", "为故障时间线补持续时间。"),
    ("b05", "将来进行时", "will be + verb-ing", "描述未来某一时刻正在进行的活动。", "At noon, the system will be running a benchmark.", "中午系统将正在运行基准测试。", "它强调时间点上的进行状态。", "为发布窗口写一条将来进行句。"),
    ("b06", "将来完成时", "will have + past participle", "表示未来某时之前将已完成的目标。", "By Friday, we will have finished the audit.", "到周五我们将完成审计。", "by + 时间点常提示完成时。", "写一条带截止日期的验收目标。"),
    ("b07", "第二条件句", "if + past, would + verb", "表达与现在事实不一定相同的假设。", "If we had more data, we would test the claim.", "如果我们有更多数据，就会测试这个主张。", "这里的过去式不一定表示过去时间。", "写一个资源受限下的反事实方案。"),
    ("b08", "第三条件句", "if + had + pp, would have + pp", "回顾过去未发生条件的可能结果。", "If we had logged the version, we would have found the cause sooner.", "如果记录了版本，我们本会更早找到原因。", "不要把 would 放进 if 从句。", "写一个故障后的反事实复盘。"),
    ("b09", "混合条件句", "if past perfect, would + verb", "把过去条件和现在结果连接起来。", "If we had fixed the path, the service would be stable now.", "如果我们修好了路径，服务现在就会稳定。", "条件的时间与结果的时间可以不同。", "把一个历史决策改写成混合条件句。"),
    ("b10", "wish/if only", "wish + past/past perfect", "表达现在遗憾、过去遗憾或愿望。", "I wish the documentation were clearer.", "我希望文档更清楚。", "wish 不是普通事实陈述。", "写一个现在限制和一个过去遗憾。"),
    ("b11", "情态被动", "modal + be + past participle", "把许可、义务、可能性与被动过程结合。", "Sensitive data must be encrypted.", "敏感数据必须被加密。", "情态词后用 be，不用 is/was。", "写三条安全规则的情态被动。"),
    ("b12", "get/have causative", "have/get + object + past participle", "表达让别人完成服务或安排某事被做。", "We had the result verified.", "我们让结果得到验证。", "causative 与普通主动动作的责任关系不同。", "把三项外包检查写成 causative。"),
    ("b13", "分词短语", "verb-ing/pp phrase + comma", "用分词短语压缩重复主语的从句。", "After checking the log, we restarted the service.", "检查日志后，我们重启了服务。", "分词短语的逻辑主语必须清楚。", "把两个带同一主语的句子压缩。"),
    ("b14", "名词性从句", "what/whether/why + clause", "把问题、原因或选择当作名词成分。", "What the test proves is limited.", "测试证明的内容是有限的。", "从句内部仍使用正常语序。", "用 what、whether、why 各写一个主语从句。"),
    ("b15", "让步从句", "although/even though + clause", "承认限制后提出仍成立的主张。", "Although the sample is small, the trend is consistent.", "尽管样本很小，趋势仍一致。", "让步不是因果；不要把 although 当 because。", "写一个带局限的研究结论。"),
    ("b16", "结果与程度从句", "so/such ... that", "表示程度导致结果。", "The input was so large that the test timed out.", "输入太大，导致测试超时。", "so 修饰形容词/副词，such 修饰名词短语。", "用一次资源耗尽现象写 so...that。"),
    ("b17", "连接副词", "however/therefore/moreover; semicolon", "连接副词组织段落逻辑，标点必须配合。", "The method is simple; however, it is slow.", "方法简单；然而它很慢。", "however 不能像 and 一样直接连接两个独立句。", "给四个句子补正确连接和标点。"),
    ("b18", "平行结构", "A, B, and C with same form", "并列项目保持相同语法形式，阅读更清楚。", "We measured time, memory, and error rate.", "我们测量了时间、内存和错误率。", "并列中途换词性会造成歧义。", "把一段列表改成平行结构。"),
    ("b19", "主谓一致进阶", "head noun controls verb", "真正的中心名词决定动词，不被 of 短语干扰。", "The set of tests is complete.", "测试集合是完整的。", "set 是单数，tests 不是主语中心。", "找出五个长主语的中心名词。"),
    ("b20", "限定与非限定信息", "restrictive vs non-restrictive", "区分决定范围的信息和补充信息，逗号改变意义。", "The tests that failed were repeated.", "失败的测试被重复。", "去掉限定从句可能改变指代范围。", "给同一句加/去逗号并解释意义差异。"),
    ("b21", "关系代词省略", "object relative omission", "关系从句中作宾语的代词有时可省略。", "The file (that) we opened was empty.", "我们打开的文件是空的。", "作主语时不能随意省略。", "判断六个关系从句能否省略代词。"),
    ("b22", "介词+关系代词", "preposition + which/whom", "正式写作中可把介词提前，关系更明确。", "The system on which the test ran was isolated.", "测试运行所在的系统是隔离的。", "口语中常把介词放句末。", "把三个句末介词句改成正式版本。"),
    ("b23", "报告动词与时态", "claim/suggest/report + that", "选择报告动词强度并让时态符合证据。", "The results suggest that the change reduced latency.", "结果表明该变化降低了延迟。", "suggest 比 prove 弱；证据不足不能过度断言。", "给同一数据写 suggest、indicate、demonstrate 三种强度。"),
    ("b24", "定义句", "X is a Y that...", "定义术语时用属概念加限定特征。", "A cache is a storage layer that keeps frequent data nearby.", "缓存是一种把高频数据放在附近的存储层。", "定义必须说明范围，不能只给同义词。", "为三个计算机术语写可检验定义。"),
    ("b25", "名词化", "verb/adjective → abstract noun", "名词化压缩过程，适合正式文体但不能过度堆叠。", "The measurement of latency was repeated.", "延迟的测量被重复了。", "过度名词化会隐藏动作主体。", "把一段名词化句改成清楚的主动句并比较。"),
]:
    add(row[0], "B1" if int(row[0][1:]) <= 13 else "B2", *row[1:])


# C1/C2/C2+: academic grammar, information structure and research discourse.
for row in [
    ("c01", "复杂名词短语", "determiner + premodifier + head + postmodifier", "论文中一个名词短语可以承载范围、方法、数据和条件。", "A reproducible evaluation of distributed systems under load is required.", "需要对负载下分布式系统进行可复现评估。", "先找中心名词，再解析前置和后置修饰。", "给一个长名词短语画括号结构。"),
    ("c02", "名词后置修饰", "noun + of/that/to/prepositional phrase", "后置短语把关系、内容或目的接到中心名词后。", "The evidence that supports the claim is public.", "支持该主张的证据是公开的。", "后置修饰不能让读者找不到中心名词。", "把三个短句压缩成后置修饰结构。"),
    ("c03", "复杂被动与施事省略", "be/get + pp + by-phrase", "正式报告突出结果，只有施事重要时才写 by。", "The dataset was released after validation.", "数据集在验证后被发布。", "无关施事不必强行写出。", "把一段实验方法改成恰当的被动。"),
    ("c04", "报告结构被动", "It is believed/argued/shown that...", "用被动报告结构表达共同知识或谨慎立场。", "It is widely believed that the method is scalable.", "人们普遍认为该方法可扩展。", "believed 不等于已被证明。", "把三条主张改成不同强度的报告被动。"),
    ("c05", "形式主语 it", "It + be + adjective + to/that...", "把长主语后置，让句子更易读。", "It is important to record the environment.", "记录环境很重要。", "it 在这里没有具体指代对象。", "把三个长主语句改写为形式主语句。"),
    ("c06", "存在句的抽象用法", "There remains/is + abstract noun", "there is/are 也可引入问题、风险和研究空白。", "There remains a gap in the evaluation.", "评估中仍存在一个空白。", "正式写作中要明确真正存在的对象。", "用 there remains 写一个研究缺口。"),
    ("c07", "分裂句", "It is X that/who...", "用 it-cleft 突出时间、原因、对象或证据。", "It was the missing log that delayed the diagnosis.", "正是缺失的日志延误了诊断。", "强调结构不应改变原命题关系。", "把三个普通句分别强调不同成分。"),
    ("c08", "伪分裂句", "What ... is ...", "用 what 从句突出过程或结果，适合解释和教学。", "What the experiment tests is robustness.", "实验测试的是稳健性。", "what 从句内部不要倒装。", "用 what 结构解释两个研究目标。"),
    ("c09", "否定副词倒装", "Never/Rarely + auxiliary + subject", "正式文体中否定或限制副词置首可触发倒装强调。", "Rarely do simple benchmarks reveal the whole risk.", "简单基准测试很少揭示全部风险。", "倒装需要助动词，不能只交换主语动词。", "把三句普通表达改成适度倒装。"),
    ("c10", "条件倒装", "Had/Were/Should + subject...", "省略 if 的正式条件句用于论文和正式答辩。", "Had we measured memory, the conclusion would differ.", "如果我们测量了内存，结论会不同。", "正式倒装不适合所有口语场景。", "把三个 if 条件句改成倒装。"),
    ("c11", "虚拟式与建议句", "It is essential that + subject + base verb", "正式建议、要求和必要性后可用 mandative subjunctive。", "It is essential that the team document the change.", "团队记录变化是必要的。", "不要写成第三人称 -s。", "写三条研究流程要求。"),
    ("c12", "不可实现假设的 were", "If I/he/she were...", "与现在事实相反的正式假设中常用 were。", "If the assumption were false, the result would change.", "如果假设是假的，结果会改变。", "were 是形式选择，不等同于过去时间。", "写一个关于假设的反事实句。"),
    ("c13", "限定语与 hedging", "may/might/could/appears to/tends to", "学术写作要让断言强度与证据强度匹配。", "The result appears to support the hypothesis.", "结果似乎支持该假设。", "hedging 不是含糊，而是诚实标注不确定性。", "把过强结论改成三档谨慎表达。", "academic"),
    ("c14", "证据与主张的时态", "present claim + past method/result", "论文常用现在时陈述本文结论，过去时叙述已完成实验。", "We found a difference, which suggests a systematic effect.", "我们发现差异，这表明存在系统效应。", "时态切换要有时间和篇章理由。", "给一段结果同时标出方法、发现和解释时态。", "academic"),
    ("c15", "平行论证结构", "not only A but also B; both A and B", "平行结构承载多项贡献、限制和证据。", "The method is not only faster but also easier to audit.", "该方法不仅更快，也更容易审计。", "not only 后的两边要同类。", "把一段贡献列表改成平行句。", "academic"),
    ("c16", "篇章指代与先行词", "this/that/these + noun", "指示词要明确指向一个命题或对象，避免 it 无所指。", "This result supports the second hypothesis.", "这一结果支持第二个假设。", "this alone 可能让读者不知道指什么。", "给四个模糊 it/this 句补出明确名词。", "academic"),
    ("c17", "主题推进与信息结构", "given information + new information", "句子顺序先接住已知信息，再引入新信息，段落更连贯。", "The baseline is stable. This stability enables comparison.", "基线稳定。这种稳定性使比较成为可能。", "不要每句都突然换主语。", "重排一个段落，使主题链连续。", "academic"),
    ("c18", "名词化与去名词化编辑", "nominal style ↔ verbal style", "学术语气与可读性需要在名词化和主动动词之间平衡。", "We evaluated the model" , "我们评估了模型。", "不是所有正式句都需要名词化。", "把五个名词化句各改成清楚的主动句，再选择更合适版本。", "academic"),
    ("c19", "引文与改述的语法", "reporting verb + quotation/paraphrase", "引用必须区分原文声音、改述内容和自己的判断。", "Smith (2024) argues that the cache reduces latency.", "Smith（2024）认为缓存降低延迟。", "改述不是只换几个同义词。", "把一条来源改成准确改述并保留限定。", "academic"),
    ("c20", "审稿回复语气", "Thank you for + gerund; We have revised...", "回复审稿人要礼貌、具体、可核查，并说明改动。", "We thank the reviewer and have clarified the limitation.", "我们感谢审稿人，并已澄清局限。", "礼貌不等于无条件接受意见。", "写一条带页码和改动位置的回复。", "academic"),
    ("c21", "摘要压缩与信息密度", "purpose + method + result + implication", "摘要用平行且高信息密度的句子呈现研究链。", "We propose a method, evaluate it on three datasets, and report lower error.", "我们提出方法，在三个数据集上评估，并报告更低错误率。", "摘要不能只写背景和愿望。", "把一段实验记录压缩成四要素摘要。", "academic"),
    ("c22", "方法、结果、讨论的语域", "method past; result past/present; discussion modal", "不同论文部分用不同语气：做过的事、观察到的事、解释与限制。", "We measured latency; the results indicate a trade-off.", "我们测量了延迟；结果表明存在取舍。", "解释不能伪装成直接观测。", "给一段文字标注 method/result/discussion 句。", "academic"),
    ("c23", "跨段连接与重述", "in contrast, consequently, nevertheless", "跨段连接词告诉读者关系是对比、结果还是让步。", "Nevertheless, the limitation does not invalidate the comparison.", "然而，该局限并不使比较失效。", "连接词必须与真实逻辑一致。", "为四段之间选择并解释连接词。", "academic"),
    ("c24", "歧义诊断与编辑", "attachment/scope ambiguity", "高级语法不仅是造句，也要发现修饰范围和代词指代的歧义。", "We tested the model with the new cache policy.", "我们用新的缓存策略测试了模型。", "new 可能修饰 model 或 cache policy，需改写。", "找出五个歧义句并给出两种明确版本。", "academic"),
    ("c25", "语域与句法选择", "formal/neutral/spoken variants", "同一命题可按课堂、工程文档、论文和答辩选择不同句法。", "The service failed. / The service was observed to fail.", "服务失败了。/观察到服务发生故障。", "更复杂不等于更准确。", "把一句话改成口语、工程和学术三个版本。", "academic"),
]:
    add(row[0], "C1" if int(row[0][1:]) <= 9 else ("C2" if int(row[0][1:]) <= 17 else "C2+"), *row[1:])


STAGE_RANGES = [
    ("A0", 1, 40),
    ("A1", 41, 100),
    ("A2", 101, 180),
    ("B1", 181, 290),
    ("B2", 291, 410),
    ("C1", 411, 500),
    ("C2", 501, 560),
    ("C2+", 561, 590),
]


def stage_for(index: int) -> str:
    for stage, start, end in STAGE_RANGES:
        if start <= index <= end:
            return stage
    return "C2+"


def main() -> None:
    matrix = json.loads((MEMORY / "掌握矩阵.json").read_text(encoding="utf-8"))
    courses = matrix if isinstance(matrix, list) else matrix.get("courses", [])
    by_stage: dict[str, list[dict]] = {}
    for topic in TOPICS:
        by_stage.setdefault(topic["stage"], []).append(topic)
    by_id = {topic["id"]: topic for topic in TOPICS}
    lessons: list[dict] = []
    primary_history: list[str] = []
    for position, course in enumerate(courses, start=1):
        stage = stage_for(position)
        bank = by_stage[stage]
        start = next(start for name, start, end in STAGE_RANGES if name == stage)
        offset = position - start
        primary = bank[offset % len(bank)]
        primary_history.append(primary["id"])
        review_ids: list[str] = []
        for distance in (1, 7, 21, 60):
            prior = position - distance
            if prior >= 1:
                candidate = primary_history[prior - 1]
                if candidate not in review_ids and candidate != primary["id"]:
                    review_ids.append(candidate)
        topics = [primary, *[by_id[item] for item in review_ids]]
        lessons.append(
            {
                "course_index": position,
                "course_id": str(course.get("id")),
                "stage": stage,
                "primary_topic_id": primary["id"],
                "grammar_topic_ids": [item["id"] for item in topics],
                "review_topic_ids": review_ids,
                "lesson_focus": primary["title"],
                "pattern": primary["pattern"],
                "explanation": primary["explanation"],
                "example": primary["example"],
                "translation": primary["translation"],
                "contrast": primary["contrast"],
                "task": primary["task"],
                "mastery_check": primary["mastery"],
            }
        )
    payload = {
        "schema_version": "v1",
        "title": "英语核心语法与学术写作 · 590 课逐课路线",
        "coverage": "A0 零基础到 C2+ 学术计算机英语：句法、时态、从句、语态、情态、篇章衔接、语域、论文结构和审稿沟通。覆盖通用现代英语核心语法；罕见方言/古英语构式不作为零基础主线，遇到真实材料时按需加入复习。",
        "honesty": "语法计划是学习路线，不等于已经掌握；每个主题都必须在平台内完成解释、改写、翻译、阅读或写作证据并经过复习。",
        "topic_count": len(TOPICS),
        "lesson_count": len(lessons),
        "topics": TOPICS,
        "lessons": lessons,
    }
    OUT.write_text(json.dumps(payload, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(f"wrote {OUT} · {len(TOPICS)} topics · {len(lessons)} lessons")


if __name__ == "__main__":
    main()
