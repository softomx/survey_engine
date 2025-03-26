let Hooks = {};

Hooks.formbrickForm = {
    mounted() {
        console.log("jjj")
        var t=document.createElement("script");t.type="text/javascript",t.async=!0,t.src="https://unpkg.com/@formbricks/js@^1.6.5/dist/index.umd.js";var e=document.getElementsByTagName("script")[0];e.parentNode.insertBefore(t,e),setTimeout(function(){window.formbricks.init({environmentId: "cm7jd1jwk000a30l593liijl3", apiHost: "https://form-surveys-formbricks-app.mbf3gu.easypanel.host"})},500)
    }
}
export default Hooks;