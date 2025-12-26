
const VoixEventHandler = {
    async mounted() {
        console.log("VoixEventHandler mounted")

        window.addEventListener("call", (event) => {
            console.log(event.target.getAttribute('name'), event.detail)
            let ev = {tool_name: event.target.getAttribute('name'), detail: event.detail}
            this.pushEvent("call", ev)
        })
    }
}

export default VoixEventHandler;