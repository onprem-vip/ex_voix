function decodeHtml(html) {
    var txt = document.createElement("textarea");
    txt.innerHTML = html;
    return txt.value;
}

const VoixEventHandler = {
    async mounted() {
        console.log("VoixEventHandler mounted")

        window.addEventListener("call", (event) => {
            console.log(event.target.getAttribute('name'), event.detail)
            let ev = {tool_name: event.target.getAttribute('name'), detail: event.detail}
            this.pushEvent("call", ev)
        })

        this.handleEvent("ui-resource-render", ({ to, resource }) => {
            // Find the target element(s) and execute the JS command stored in an attribute
            document.querySelectorAll(to).forEach(el => {
                if (resource && resource.mimeType == 'application/vnd.ex-voix.command+javascript; framework=liveviewjs') {
                    let attr = el.getAttribute('value-js-code')
                    console.log(attr);
                    if (attr) {
                        liveSocket.execJS(el, attr);
                    }
                } else {
                    if (resource && (
                        resource.mimeType == 'application/vnd.mcp-ui.remote-dom+javascript; framework=webcomponents' ||
                        resource.mimeType == 'application/vnd.mcp-ui.remote-dom+javascript; framework=react' ||
                        resource.mimeType == 'text/html' || resource.mimeType == 'text/uri-list'
                    )) {
                        el.resource = resource
                        el.remoteDomProps = {library: basicComponentLibrary, remoteElements: remoteElements}
                        el.htmlProps = {}

                        el.addEventListener('onUIAction', (event) => {
                            console.log('Action received:', event.detail);
                            document.querySelectorAll('ui-text').forEach(ui_text => {
                                let txt = ui_text.getAttribute('content');
                                ui_text.setAttribute('content', decodeHtml(txt));
                            })
                        });
                    }
                }
            });
        });

    }
}

export default VoixEventHandler;