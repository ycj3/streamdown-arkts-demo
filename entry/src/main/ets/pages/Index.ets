import { 
  StreamingMarkdown, 
  StreamingMode 
} from '@ycj3/streaming-markdown'

const fullMarkdownText: string = `
# StreamingMarkdown Demo

Welcome to **StreamingMarkdown** - A streaming markdown renderer for HarmonyOS!

Visit our [GitHub repository](https://github.com/ycj3/streaming-markdown) for more info.

## 1. Inline Styles
- **Bold text** with double asterisks
- *Italic text* with single asterisks
- ~~Strikethrough text~~ with double tildes
- ***Bold and Italic*** combined

## 2. Inline Code Priority
- Normal \`inline code\`
- Verbatim: \`**this is not bold**\` (Markdown standard: code shields styles)
- Mixed: **Bold** and then \`code\`

## 3. Unordered Lists
- First item with **bold**
- Second item with *italic*
- Third item with \`inline code\`
- Nested styles: ***bold italic*** and ~~strikethrough~~

## 4. Ordered Lists
1. First ordered item
2. Second ordered item with **bold**
3. Third ordered item with \`code\`

## 5. Task Lists
- [ ] Unchecked task item
- [x] Checked task item
- [X] Another checked task

## 6. Blockquotes
> This is a blockquote
> With multiple lines
> And **bold** text inside

## 7. Horizontal Rule

---

## 8. Fenced Code Block
\`\`\`typescript
function hello() {
  console.log("Hello StreamingMarkdown!");
}
\`\`\`

## 9. Tables

| Syntax | Description |
|:--------|:------:|
| Header | Title |
| Paragraph | Text |

Enjoy the smooth streaming experience! 🚀
`

const TestCases: Record<string, string> = {
  'Table Basic': `| Header 1 | Header 2 |\n|---|---|\n| Row 1 Col 1 | Row 1 Col 2 |\n| Row 2 Col 1 | Row 2 Col 2 |`,
  'Table Alignment': `| Left | Center | Right |\n|:---|:---:|---:|\n| L-content | C-content | R-content |`,
  'Full markdown': fullMarkdownText,
}

@Entry
@Component
struct Index {
  @State currentMode: StreamingMode = 'char'
  @State contentKey: number = 0
  @State activeText: string = TestCases['Table Basic']

  // Helper to trigger re-render
  private refresh(text: string) {
    this.activeText = text
    this.contentKey++
  }

  @Builder
  ModeButton(mode: StreamingMode, label: string) {
    Button(label)
      .fontSize(14)
      .height(36)
      .backgroundColor(this.currentMode === mode ? '#1976D2' : '#E0E0E0')
      .fontColor(this.currentMode === mode ? '#FFFFFF' : '#333333')
      .onClick(() => {
        if (this.currentMode !== mode) {
          this.currentMode = mode
          // Force re-render with new mode
          this.contentKey++
        }
      })
  }

  build() {
    Column() {
      // Header with mode selection
      Column() {
        Text('Streaming Mode')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .margin({ bottom: 12 })

        Row({ space: 8 }) {
          this.ModeButton('char', 'Char')
          this.ModeButton('word', 'Word')
          this.ModeButton('chunk', 'Chunk')
        }
        .width('100%')
        .justifyContent(FlexAlign.Center)

        Text(`Current: ${this.currentMode} by ${this.currentMode}`)
          .fontSize(12)
          .fontColor('#666666')
          .margin({ top: 8 })
      }
      .width('100%')
      .padding(16)
      .backgroundColor('#F5F5F5')

      Divider().margin({ top: 15, bottom: 15 })
      // Feature Selection Row
      Text("Feature Scenarios").fontSize(14).fontColor('#666').margin({ bottom: 8 })
      Scroll() {
        Row({ space: 10 }) {
          ForEach(Object.keys(TestCases), (name: string) => {
            Button(name)
              .fontSize(12)
              .height(32)
              .backgroundColor(this.activeText === TestCases[name] ? '#007DFF' : '#E5E5E5')
              .fontColor(this.activeText === TestCases[name] ? '#FFFFFF' : '#333333')
              .onClick(() => this.refresh(TestCases[name]))
          })
        }
      }
      .scrollable(ScrollDirection.Horizontal)
      .scrollBar(BarState.Off)
      .width('100%')

      // Content - Use ForEach with key to force re-creation
      Scroll() {
        Column() {
          // Use ForEach with unique key to force component re-creation
          ForEach([this.contentKey], (key: number) => {
            StreamingMarkdown({
              text: this.activeText,
              mode: this.currentMode,
              interval: 30,
              onComplete: () => {
                console.log('Streaming completed!')
              }
            })
          }, (key: number) => key.toString())
        }
        .padding(16)
        .width('100%')
      }
      .layoutWeight(1)
      .width('100%')

      // Replay button
      Button('Replay')
        .fontSize(16)
        .width(120)
        .height(44)
        .margin(16)
        .backgroundColor('#4CAF50')
        .onClick(() => {
          // Increment key to force ForEach to re-create the component
          this.contentKey++
        })
    }
    .width('100%')
    .height('100%')
  }
}
