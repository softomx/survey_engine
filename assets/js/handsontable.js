import customHandsontable from  "../vendor/handsontable/handsontable.full.min.js";
import esMX from "../vendor/handsontable/es-MX.min.js";

let Handsontable =  {
 mounted() {
  var table = null
  this.handleEvent("initHandSomeTable", (event) => {
    table = new customHandsontable(this.el, {
          data: event.rows,
          columns: event.cols,
          width: '100%',
          rowHeaders: true,
          manualColumnMove: true,
          columnSorting: true,
          height: "800",
          licenseKey: 'non-commercial-and-evaluation',
          filters: true,
          dropdownMenu: true,
          language: "es-MX"
       })
   }) 
   this.handleEvent("export", ({filename}) => {
    const exportPlugin = table.getPlugin('exportFile');
    exportPlugin.downloadFile('csv', {
      bom: true,
      columnDelimiter: ',',
      columnHeaders: true,
      exportHiddenColumns: true,
      exportHiddenRows: true,
      fileExtension: 'csv',
      filename: filename,
      mimeType: 'text/csv',
      rowDelimiter: '\r\n',
      rowHeaders: false
    });
   }) 
 }
}


export default Handsontable;