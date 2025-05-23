import Handsontable from "./handsontable";
import EasyMDE from "../vendor/easymde";
import IMask from "../vendor/imask";
import jquery from "../vendor/jquery";
window.$ = jquery
import "../vendor/daterangepicker";

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

  Hooks.PhoneInput = {
    mounted() {
      let startNumber = this.el.dataset.startNumber
      let country = this.el.dataset.country
      console.log(this.el.dataset, "create")
      let input = IMask(this.el, {
        mask: [
          {
            mask: `{${startNumber}}(000)000-00-00`,
            startsWith: startNumber,
            country: country,
            lazy: false,
          }]
          
        ,
      });
      let target = this.el
      this.handleEvent("update-input-phone", ({country, start_number} ) => {
       
        input.updateOptions({
        mask: `{${start_number}}(000)000-00-00`,
        startsWith: start_number,
        country: country,
        lazy: false
      }) })
    }
    
  }

Hooks.DateRanges = {
    mounted() {
    
      let {startDateTarget, endDateTarget} = this.el.dataset
      $(`#${this.el.id}`).daterangepicker({
        opens: 'left',
        locale: {
          format: 'YYYY-MM-DD',
          separator: " a "
        }
      }, function(start, end, label) {
        console.log("A new date selection was made: " + start.format('DD/MM/YYYY') + ' - ' + end.format('DD/MM/YYYY'));
        $(`#${startDateTarget}`).val(start.format('YYYY-MM-DD'))
        $(`#${endDateTarget}`).val(end.format('YYYY-MM-DD'))
      });
     
  
    $(`#${this.el.id}`).on('cancel.daterangepicker', function(ev, picker) {
        $(this).val('');
    });
    }
  }
Hooks.PasswordValidation = {
  mounted(){

    var passwordInput = this.el
    var passwordMessageItems = document.getElementsByClassName("password-message-item");
var passwordMessage = document.getElementById("password-message");
  //   passwordInput.onfocus = function () {
  //     passwordMessage.style.display = "block";
  // }
  
  // // After clicking outside of password input hide the message
  // passwordInput.onblur = function () {
  //     passwordMessage.style.display = "block";
  // }
  
  passwordInput.onkeyup = function () {
      // checking uppercase letters
      let uppercaseRegex = /[A-Z]/g;
      if (passwordInput.value.match(uppercaseRegex)) {
          passwordMessageItems[1].classList.remove("invalid");
          passwordMessageItems[1].classList.add("valid");
      } else {
          passwordMessageItems[1].classList.remove("valid");
          passwordMessageItems[1].classList.add("invalid");
      }
  
      // checking lowercase letters
      let lowercaseRegex = /[a-z]/g;
      if (passwordInput.value.match(lowercaseRegex)) {
          passwordMessageItems[0].classList.remove("invalid");
          passwordMessageItems[0].classList.add("valid");
      } else {
          passwordMessageItems[0].classList.remove("valid");
          passwordMessageItems[0].classList.add("invalid");
      }
  
      // checking the number
      let numbersRegex = /[0-9]/g;
      if (passwordInput.value.match(numbersRegex)) {
          passwordMessageItems[2].classList.remove("invalid");
          passwordMessageItems[2].classList.add("valid");
      } else {
          passwordMessageItems[2].classList.remove("valid");
          passwordMessageItems[2].classList.add("invalid");
      }
  
      // Checking length of the password
      if (passwordInput.value.length >= 12) {
          passwordMessageItems[3].classList.remove("invalid");
          passwordMessageItems[3].classList.add("valid");
      } else {
          passwordMessageItems[3].classList.remove("valid");
          passwordMessageItems[3].classList.add("invalid");
      }
  }
  }
}

Hooks.Handsontable = Handsontable

export default Hooks;