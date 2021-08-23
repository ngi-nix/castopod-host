import MarkdownToolbarElement from "@github/markdown-toolbar-element";
import { html, LitElement, TemplateResult } from "lit";
import { customElement, property } from "lit/decorators.js";
import { unsafeHTML } from "lit/directives/unsafe-html.js";
import marked from "marked";

@customElement("markdown-preview")
export class MarkdownPreview extends LitElement {
  @property()
  for!: string;

  @property()
  _textarea!: HTMLTextAreaElement;

  @property()
  _markdownToolbar!: MarkdownToolbarElement;

  @property()
  _show = false;

  connectedCallback(): void {
    super.connectedCallback();

    this._textarea = document.getElementById(this.for) as HTMLTextAreaElement;
    this._markdownToolbar = document.querySelector(
      `markdown-toolbar[for=${this.for}]`
    ) as MarkdownToolbarElement;
  }

  hide(): void {
    this._show = false;
    this.classList.add("hidden");
    this._markdownToolbar.classList.remove("hidden");
  }

  show(): void {
    this._show = true;
    this.classList.remove("hidden");
    this._markdownToolbar.classList.add("hidden");
  }

  markdownToHtml(): string {
    const renderer = new marked.Renderer();
    renderer.link = function () {
      // eslint-disable-next-line prefer-rest-params
      const link = marked.Renderer.prototype.link.apply(this, arguments as any);
      return link.replace("<a", "<a target='_blank' rel='noopener noreferrer'");
    };

    return marked(this._textarea.value, {
      renderer: renderer,
    });
  }

  render(): TemplateResult<1> {
    return html`${this._show
      ? html`${unsafeHTML(this.markdownToHtml())}`
      : html``}`;
  }
}
