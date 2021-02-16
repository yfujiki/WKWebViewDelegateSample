## WKNavigationDelegateSample
Trying to summarise the behavior of WKNavigationDelegate

## Summary

### Normal flow for the main frame

1. `webView(_:,decidePolicyFor navigationAction:,decisionHandler:)` or `webView(_:,decidePolicyFor navigationAction:, preferences:, decisionHandler:)`

You can decide whether to start navigation for the action. You can for example check whether the navigation triggered a new window and reject that navigation by 
```
if navigationAction.targetFrame == nil {
    decisionHandler(.cancel)
}
```

With the callback with `preferences`, you can check WKWebView's preference as well. For example, you can check whether JavaScript is disabled and reject the navigation by
```
if !preferences.allowContentJavascript {
    decisionHandler(.cancel)
}
```

If both callback is implemented, `webView(_:,decidePolicyFor navigationAction:, preferences:, decisionHandler:)` precedes.

2. `webView(_,didStartProvisionalNavigation:)`

Start navigation and send request to the URL.

3. `webView(_,decidePolicyFor navigationResponse:,decisionHandler:)`

You can decide whether to render the received response to commit navigation. For example, you can pass only status code 200~399

```
let statusCode = (navigationResponse.response as? HTTPURLResponse)?.statusCode ?? -1
switch statusCode {
case 200..<400:
    decisionHandler(.allow)
default:
    decisionHandler(.cancel)
}
```

4. `webView(_,didCommit)`

5. `webView(_:,didFinish)`

### Normal flow for iframe

1. `webView(_:,decidePolicyFor navigationAction:,decisionHandler:)` or `webView(_:,decidePolicyFor navigationAction:, preferences:, decisionHandler:)`
2. `webView(_,decidePolicyFor navigationResponse:,decisionHandler:)`

didCommit or didFinish callbacks are not called. Only the callbacks that require your decision for navigation is called. 
When an iframe is embedded in the main page, iframe navigation starts after main page's `didCommit`.

### Error flow for main frame.

In case it failed with wrong response code:
1. `webView(_:,decidePolicyFor navigationAction:,decisionHandler:)` or `webView(_:,decidePolicyFor navigationAction:, preferences:, decisionHandler:)`
2. `webView(_,didStartProvisionalNavigation:)`
3. `webView(_,decidePolicyFor navigationResponse:,decisionHandler:)`
4. `webView(_,didFailProvisionalNavigation navigation:,withError)`

### Error flow for iframe

In case it failed with wrong response code (Same as normal flow. No callback to `didFailProvisionalNavigation:`):

1. `webView(_:,decidePolicyFor navigationAction:,decisionHandler:)` or `webView(_:,decidePolicyFor navigationAction:, preferences:, decisionHandler:)`
2. `webView(_,decidePolicyFor navigationResponse:,decisionHandler:)`

### Images (`<img>` tag) or scripts (`<script>` tag)

Doesn't call any callbacks whatsoever. 

The description of `webView(_:didFailProvisionalNavigation:withError:)` is a bit confusing in saying that 

```
Called when an error occurs while the web view is loading content.
```

Giving the impression that it would error when loading content (CSS/image/script), but I guess it just means content of the navigation (html).

