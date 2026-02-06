# @ycj3/streamdown

A streaming markdown renderer for HarmonyOS ArkTS, designed for real-time LLM chat interfaces.

> [中文版本](./README.md)

---

## Features

- **Streaming Parser**: Incrementally renders markdown as characters arrive
- **Block-based Architecture**: Efficient updates via immutable diffs
- **Rich Text Support**:
  - Headings (`# H1` to `###### H6`)
  - Paragraphs with inline styles
  - **Bold** (`**text**`)
  - *Italic* (`*text*`)
  - ***Bold + Italic*** (`***text***`)
  - ~~Strikethrough~~ (`~~text~~`)
  - Inline code (`` `code` ``)
  - Fenced code blocks (```` ```lang ``` ````)
    - Copy button
    - Syntax highlighting

---

## Installation

### Local HAR Module

Add to your project's `entry/oh-package.json5`:

```json5
{
  "dependencies": {
    "@ycj3/streamdown": "file:../streamdown"
  }
}
```

Then sync the project in DevEco Studio.

---

## Usage

```typescript
import { StreamDown, createStreamDown } from '@ycj3/streamdown'

@Entry
@Component
struct MyPage {
  private stream = createStreamDown()

  aboutToAppear() {
    // Simulate streaming markdown (e.g., from LLM)
    const markdown = `# Hello StreamDown

This is **bold** and *italic* text.

\`\`\`typescript
console.log("Hello World");
\`\`\`
`
    let i = 0
    const timer = setInterval(() => {
      if (i >= markdown.length) {
        clearInterval(timer)
        this.stream.close()  // Finalize parsing
        return
      }
      this.stream.push(markdown.charAt(i))  // Push char by char
      i++
    }, 30)
  }

  build() {
    Scroll() {
      StreamDown({ controller: this.stream })
        .padding(16)
    }
    .width('100%')
    .height('100%')
  }
}
```

---

## API Reference

### `createStreamDown()`

Creates a new `StreamDownController` instance.

**Returns**: `StreamDownController`

### `StreamDownController`

The controller for managing markdown streaming.

| Method | Description |
|--------|-------------|
| `push(char: string)` | Process a single character incrementally |
| `close()` | Finalize parsing, handles incomplete inline code |
| `subscribe(listener)` | Listen for block diff updates |

### `StreamDown` Component

The UI component that renders the markdown blocks.

**Props**:

| Prop | Type | Description |
|------|------|-------------|
| `controller` | `StreamDownController` | The controller instance |

---

## Architecture

```
Data Input     Parser       Diff Updates   UI Component
   │            │               │            │
   ▼            ▼               ▼            ▼
┌────────┐  ┌──────────┐    ┌────────┐   ┌──────────┐
│ Char   │─▶│BlockReducer│─▶│BlockDiff│──▶│StreamDown│
│ Stream │  │(State Machine)│  │(Immutable)│   │(ArkTS List)│
└────────┘  └──────────┘    └────────┘   └──────────┘
```

The parser uses a state machine with diff-based updates for efficient rendering of streaming content.

---

## Requirements

- HarmonyOS API 6.0.1+
- DevEco Studio 4.0+

---

## License

MIT
