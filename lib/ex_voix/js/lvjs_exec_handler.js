const LvjsExecHandler = {
    async mounted() {
        console.log("LvjsExecHandler mounted")

        this.handleEvent("lvjs-exec", ({ to, attr }) => {
            // Find the target element(s) and execute the JS command stored in an attribute
            document.querySelectorAll(to).forEach(el => {
                liveSocket.execJS(el, el.getAttribute(attr));
            });
        });
    }
}

export default LvjsExecHandler;
