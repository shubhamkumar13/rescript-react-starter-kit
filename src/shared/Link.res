@react.component
let make = (
  ~href,
  ~matchHref=?,
  ~className=?,
  ~style=?,
  ~activeClassName=?,
  ~activeStyle=?,
  ~matchSubroutes=false,
  ~title=?,
  ~children,
) => {
  let url = RescriptReactRouter.useUrl()
  let path = url.path->List.reduce("", (acc, item) => acc ++ "/" ++ item)
  let compareHref = matchHref->Option.getWithDefault(href)
  let isActive = matchSubroutes
    ? String.startsWith(compareHref, path ++ "/") || String.startsWith(compareHref, path)
    : path === compareHref || path ++ "/" === compareHref
  <a
    href
    ?title
    className={CssJs.merge(.
      [className, isActive ? activeClassName : None]->Belt.Array.keepMap(x => x),
    )}
    style=?{switch (style, isActive ? activeStyle : None) {
    | (Some(a), Some(b)) => Some(ReactDOM.Style.combine(a, b))
    | (Some(a), None) => Some(a)
    | (None, Some(b)) => Some(b)
    | (None, None) => None
    }}
    onClick={event => {
      switch (ReactEvent.Mouse.metaKey(event), ReactEvent.Mouse.ctrlKey(event)) {
      | (false, false) =>
        event->ReactEvent.Mouse.preventDefault
        RescriptReactRouter.push(href)
      | _ => ()
      }
    }}>
    children
  </a>
}
