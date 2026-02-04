import { Block, CodeBlock, TextSegment } from '../core/protocol'
import { CodeBlockHeader } from './code-block/CodeBlockHeader'
import { CodeBlockBody } from './code-block/CodeBlockBody'
@Component
export struct BlockView {
  @Prop block: Block;

  parseSegments(text: string): TextSegment[] {
    let segments: TextSegment[] = [];
    let regex = /`([^`]+)`/g;
    let lastIndex = 0;
    let match: RegExpExecArray | null;

    while ((match = regex.exec(text)) !== null) {
      if (match.index > lastIndex) {
        let seg = new TextSegment();
        seg.content = text.substring(lastIndex, match.index);
        seg.isCode = false;
        segments.push(seg);
      }
      let codeSeg = new TextSegment();
      codeSeg.content = match[1];
      codeSeg.isCode = true;
      segments.push(codeSeg);
      lastIndex = regex.lastIndex;
    }

    if (lastIndex < text.length) {
      let lastSeg = new TextSegment();
      lastSeg.content = text.substring(lastIndex);
      lastSeg.isCode = false;
      segments.push(lastSeg);
    }
    return segments;
  }

  build() {
    Column() {
      if (this.block.type === 'paragraph') {
        Text() {
          ForEach(this.parseSegments(this.block.text), (seg: TextSegment) => {
            if (seg.isCode) {
              Span(seg.content)
                .fontFamily('monospace')
                .fontColor('#D32F2F')
                .fontSize(14)
                .textBackgroundStyle({ color: '#F5F5F5', radius: 4 })
            } else {
              Span(seg.content)
                .fontSize(16)
                .fontColor('#333333')
            }
          })
        }
        .width('100%')
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
      }
    }
    .width('100%')
    .alignItems(HorizontalAlign.Start)
  }
}
