function main(workbook: ExcelScript.Workbook) {
  let today = new Date();
  let currentYear = today.getFullYear();

  // If today is May or later, prepare for next FY
  let fiscalYear = today.getMonth() >= 4 ? currentYear + 1 : currentYear;

  const monthMap: {[key: string]: number} = {
    "Jul": 6, "Aug": 7, "Sep": 8, "Oct": 9, "Nov": 10, "Dec": 11,
    "Jan": 0, "Feb": 1, "Mar": 2, "Apr": 3, "May": 4, "Jun": 5
  };

  workbook.getWorksheets().forEach(sheet => {
    let sheetName = sheet.getName();

    if (monthMap.hasOwnProperty(sheetName)) {
      let monthIndex = monthMap[sheetName];
      let year = (monthIndex >= 6) ? fiscalYear - 1 : fiscalYear;

      // Use UTC to avoid time zone issues
      let jsDate = new Date(Date.UTC(year, monthIndex, 1));
      let excelDate = convertJsDateToExcelSerial(jsDate);

      // Set A3 to date and format
      let cell = sheet.getRange("A3");
      cell.setValue(excelDate);
      cell.setNumberFormatLocal("M/D/YYYY");

      // Copy A3 downward (entire used column A)
      let lastRow = sheet.getUsedRange().getRowCount();
      let colARange = sheet.getRangeByIndexes(2, 0, lastRow - 2, 1); // From A3 downward

      // Get values from column A
      let valuesOnly = colARange.getValues();

      // Overwrite same range with just values (no formulas)
      colARange.setValues(valuesOnly);
    }
  });
}

// Helper function: Convert JavaScript UTC date to Excel serial number
function convertJsDateToExcelSerial(date: Date): number {
  const msPerDay = 1000 * 60 * 60 * 24;
  const excelEpoch = Date.UTC(1899, 11, 30); // Dec 30, 1899
  return (date.getTime() - excelEpoch) / msPerDay;
}
