
const VoixEventHandler = {
    async mounted() {
        console.log("VoixEventHandler mounted")

        window.addEventListener("call", (event) => {
            console.log(event.target.getAttribute('name'), event.detail)
            let ev = {tool_name: event.target.getAttribute('name'), detail: event.detail}
            this.pushEvent("call", ev)
        })

        this.handleEvent("lvjs-exec", ({ to }) => {
            // Find the target element(s) and execute the JS command stored in an attribute
            document.querySelectorAll(to).forEach(el => {
                let attr = el.getAttribute('value-js-code')
                if (attr && attr != '') {
                    liveSocket.execJS(el, attr);
                }
            });
        });
    }
}

export default VoixEventHandler;