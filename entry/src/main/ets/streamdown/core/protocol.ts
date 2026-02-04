export type ParagraphBlock = {
  id: number
  type: 'paragraph'
  text: string
}

export type CodeBlock = {
  id: number
  type: 'code'
  lang?: string
  text: string
}

export type InlineCodeBlock = {
  id: number
  type: 'inlineCode'
  text: string
}

export type Block = ParagraphBlock | CodeBlock | InlineCodeBlock

export type BlockDiff =
  | { kind: 'append'; block: Block }
    | { kind: 'patch'; id: number; block: Block }
