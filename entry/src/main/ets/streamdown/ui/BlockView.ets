import { Block, CodeBlock } from '../core/protocol'
import { CodeBlockHeader } from './code-block/CodeBlockHeader'
import { CodeBlockBody } from './code-block/CodeBlockBody'
@Component
export struct BlockView {
  @Prop block: Block;

  build() {
    if (this.block.type === 'paragraph') {
      Text(this.block.text)
        .fontSize(16)
        .fontColor('#333333')
        .margin({ bottom: 8 })
    } else if (this.block.type === 'code') {
      Column() {
        CodeBlockHeader({
          language: (this.block as CodeBlock).lang || '',
          code: this.block.text
        })
        Divider().color('#EEEEEE').strokeWidth(1)
        CodeBlockBody({
          code: this.block.text,
          language: (this.block as CodeBlock).lang || ''
        })
      }
      .alignItems(HorizontalAlign.Start)
      .margin({ top: 16, bottom: 16 })
      .width('100%')
      .clip(true)
      .borderRadius(12)
      .border({ width: 1, color: '#E5E5E5' })
    } else if (this.block.type === 'inlineCode') {
      Text(this.block.text)
        .fontFamily('monospace')
        .fontColor('#D32F2F')
        .fontSize(14)
        .backgroundColor('#F5F5F5')
        .padding({ left: 4, right: 4, top: 2, bottom: 2 })
        .borderRadius(4)
        .margin({ bottom: 8 })
    }
  }
}
