import { Block } from '../core/protocol'
import { CodeBlockHeader } from './code-block/CodeBlockHeader'
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

        if (this.block.lang) {
          Text(this.block.lang)
            .fontSize(12)
            .opacity(0.6)
            .margin({ bottom: 4 })
        }
        CodeBlockHeader({
          language: this.block.lang,
          code: this.block.text
        })
        Divider().color('#EEEEEE').strokeWidth(1)
        Text(this.block.text)
          .fontFamily('monospace')
          .fontColor('#4A4A4A')
          .fontSize(14)
          .padding(16)
      }
      .alignItems(HorizontalAlign.Start)
      .margin({ top: 16, bottom: 16 })
      .width('100%')
      .clip(true)
      .borderRadius(12)
      .border({ width: 1, color: '#E5E5E5' })
    }
  }
}
