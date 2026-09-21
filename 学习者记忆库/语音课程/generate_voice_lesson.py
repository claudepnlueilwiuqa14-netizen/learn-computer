"""Generate alternating English/Chinese lesson audio with Microsoft Edge voices."""

from __future__ import annotations

import argparse
import asyncio
import json
import shutil
import subprocess
import tempfile
from pathlib import Path

import edge_tts


VOICE_BY_LANGUAGE = {
    "en": "en-GB-RyanNeural",
    "zh": "zh-CN-YunyangNeural",
}


async def synthesize(turn: dict, target: Path) -> None:
    language = turn["language"]
    voice = turn.get("voice") or VOICE_BY_LANGUAGE[language]
    communicate = edge_tts.Communicate(turn["text"], voice=voice, rate=turn.get("rate", "+0%"))
    await communicate.save(str(target))


def run_ffmpeg(parts: list[Path], output: Path) -> None:
    ffmpeg = shutil.which("ffmpeg")
    if not ffmpeg:
        raise RuntimeError("找不到 ffmpeg，无法合并语音片段")
    concat = output.with_suffix(".concat.txt")
    concat.write_text("\n".join(f"file '{part.as_posix()}'" for part in parts), encoding="utf-8")
    try:
        subprocess.run(
            [ffmpeg, "-y", "-f", "concat", "-safe", "0", "-i", str(concat), "-c", "copy", str(output)],
            check=True,
            capture_output=True,
            text=True,
        )
    finally:
        concat.unlink(missing_ok=True)


async def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--input", required=True, type=Path)
    parser.add_argument("--output", required=True, type=Path)
    args = parser.parse_args()
    lesson = json.loads(args.input.read_text(encoding="utf-8"))
    turns = lesson["turns"]
    if not turns:
        raise ValueError("课堂脚本至少需要一个 turn")
    args.output.parent.mkdir(parents=True, exist_ok=True)
    with tempfile.TemporaryDirectory(prefix="voice-lesson-") as temp:
        temp_path = Path(temp)
        parts: list[Path] = []
        for index, turn in enumerate(turns, 1):
            if turn.get("language") not in VOICE_BY_LANGUAGE:
                raise ValueError(f"不支持的语言：{turn.get('language')}")
            part = temp_path / f"{index:03d}.mp3"
            await synthesize(turn, part)
            parts.append(part)
        run_ffmpeg(parts, args.output)
    print(f"Generated: {args.output.resolve()}")
    print(f"Turns: {len(turns)}")


if __name__ == "__main__":
    asyncio.run(main())

