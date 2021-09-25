import React from 'react'

const html = {}

// from https://stackoverflow.com/questions/21170255/can-anyone-point-me-to-or-post-an-array-of-every-html-tag
const tags = [
  'a', 'abbr', 'acronym', 'address', 'applet', 'area', 'article', 'aside',
  'audio', 'b', 'base', 'basefont', 'bdi', 'bdo', 'bgsound',
  'big',
  'blink',
  'blockquote',
  'body',
  'br',
  'button',
  'canvas',
  'caption',
  'center',
  'cite',
  'code',
  'col',
  'colgroup',
  'content',
  'data',
  'datalist',
  'dd',
  'decorator',
  'del',
  'details',
  'dfn',
  'dir',
  'div',
  'dl',
  'dt',
  'element',
  'em',
  'embed',
  'fieldset',
  'figcaption',
  'figure',
  'font',
  'footer',
  'form',
  'frame',
  'frameset',
  'h1',
  'h2',
  'h3',
  'h4',
  'h5',
  'h6',
  'head',
  'header',
  'hgroup',
  'hr',
  'html',
  'i',
  'iframe',
  'img',
  'input',
  'ins',
  'isindex',
  'kbd',
  'keygen',
  'label',
  'legend',
  'li',
  'link',
  'listing',
  'main',
  'map',
  'mark',
  'marquee',
  'menu',
  'menuitem',
  'meta',
  'meter',
  'nav',
  'nobr',
  'noframes',
  'noscript',
  'object',
  'ol',
  'optgroup',
  'option',
  'output',
  'p',
  'param',
  'plaintext',
  'pre',
  'progress',
  'q',
  'rp',
  'rt',
  'ruby',
  's',
  'samp',
  'script',
  'section',
  'select',
  'shadow',
  'small',
  'source',
  'spacer',
  'span',
  'strike',
  'strong',
  'style',
  'sub',
  'summary',
  'sup',
  'table',
  'tbody',
  'td',
  'template',
  'textarea',
  'tfoot',
  'th',
  'thead',
  'time',
  'title',
  'tr',
  'track',
  'tt',
  'u',
  'ul',
  'var',
  'video',
  'wbr',
  'xmp'
]

// parse the different tag parameter configurations into an object:
// {options: {}, children: []}
// NOTE: does not support spread children
html.params = (key, options, ...children) => {
  // short circuit string to empty options and one child, the string
  if (typeof options === 'string') {
    return { options: { key: key }, children: [options] }
  }

  // short circuit options already in the correct format
  if (
    typeof options === 'object' &&
    !(options instanceof Array) &&
    typeof options.options === 'object' &&
    options.children instanceof Array
  ) {
    options.key = key
    return options
  }

  // object and array
  if (
    typeof options === 'object' &&
    !(options instanceof Array) &&
    children instanceof Array &&
    children.length == 1 &&
    children[0] instanceof Array
  ) {
    options.key = key
    return { options: options, children: children[0] }
  }

  // only array
  if (options instanceof Array && children instanceof Array && children.length == 1) {
    return { options: { key: key }, children: options }
  }

  // no args
  if (typeof options === 'undefined') {
    return { options: { key: key }, children: children }
  }

  // default passthrough
  options.key = key
  return { options: options, children: children }
}

html.param_test = (string, params, expected) => {
  console.log(string, params, expected)
}

html.tagifyOne = (tag) => {
  return (key, options, ...children) => {
    const params = html.params(key, options, children)
    return html.tag(tag, key, params)
  }
}

html.tagifyArray = (tags) => {
  return tags.map((tag, i) => html.tagifyOne(tag))
}

html.tagify = (tag_or_tags) => {
  if (typeof tag_or_tags !== 'Array') { tag_or_tags = [tag_or_tags] }

  return html.tagifyArray(tag_or_tags)
}

html.tag = (tag, key, options, ...children) => {
  const params = html.params(key, options, children)

  // make children null in certain circumstances
  if (typeof params.options.dangerouslySetInnerHTML !== 'undefined' || tag == 'textarea' || tag == 'input' || tag == 'hr') {
    // TODO: please dont user dangerouslySetInnerHTML
    params.children = null
  }
  return React.createElement(tag, params.options, params.children)
}

tags.forEach(tag => {
  html[tag] = (key, options, ...children) => {
    const params = html.params(key, options, children)
    return html.tag(tag, key, params)
  }
})

html.nbsp = (key, options, ...children) => {
  return html.tag('span', options, String.fromCharCode(160))
}

export default html
