import Handsontable from "./handsontable";
import EasyMDE from "../vendor/easymde"

let Hooks = {};

Hooks.MarkDownEditor = {
    mounted() {
      create_editor(this.el)
    },
    updated() {
      create_editor(this.el)
    }
  }
  
  let create_editor = (el) => {
    return new EasyMDE({maxHeight: "300px", element: el, toolbar: ["bold", "italic", "strikethrough","horizontal-rule","heading", "quote","code", "link", "table", "unordered-list", "ordered-list", "horizontal-rule","preview", "guide"]})
  }

Hooks.formbrickForm = {
    mounted() {
        console.log("jjj")
        var t=document.createElement("script");t.type="text/javascript",t.async=!0,t.src="https://unpkg.com/@formbricks/js@^1.6.5/dist/index.umd.js";var e=document.getElementsByTagName("script")[0];e.parentNode.insertBefore(t,e),setTimeout(function(){window.formbricks.init({environmentId: "cm7jd1jwk000a30l593liijl3", apiHost: "https://form-surveys-formbricks-app.mbf3gu.easypanel.host"})},500)
    }
}

Hooks.Copy = {
  mounted() {
    this.el.addEventListener("click", async () => {
      const textToCopy = this.el.dataset.clipboardText || this.el.innerText;

      try {
        await navigator.clipboard.writeText(textToCopy);
        this.el.innerText = "Copiado!";
      } catch (err) {
        console.error("Error al copiar al portapapeles", err);
      }
    });
  }
}

Hooks.BeforeUnload = {
    mounted() {
      var el = this.el
      console.log(el.dataset)
      this.beforeUnload = function(e) {
        if (el.dataset.changesMade === 'true') {
            console.log('Changes made')
          e.preventDefault()
          e.returnValue = ''
        }
      }
      window.addEventListener('beforeunload', this.beforeUnload, true)
    },
    destroyed() {
      window.removeEventListener('beforeunload', this.beforeUnload, true)
    }
  }

Hooks.Handsontable = Handsontable

export default Hooks;