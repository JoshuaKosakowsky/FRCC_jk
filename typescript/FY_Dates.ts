function main(workbook: ExcelScript.Workbook) {
  let today = new Date();
  let currentYear = today.getFullYear();

  // If today is May (4) or later, next fiscal year
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

      let jsDate = new Date(year, monthIndex, 1); // JavaScript Date object

      // Excel date is the number of days since Jan 1, 1900
      let excelDate = convertJsDateToExcelSerial(jsDate);

      let cell = sheet.getRange("A3");
      cell.setValue(excelDate);
      cell.setNumberFormatLocal("M/D/YYYY");
    }
  });
}

// Helper: Convert JavaScript Date to Excel serial number
function convertJsDateToExcelSerial(date: Date): number {
  const msPerDay = 1000 * 60 * 60 * 24;
  const excelStartDate = new Date(1899, 11, 30); // Excel's day 1
  return (date.getTime() - excelStartDate.getTime()) / msPerDay;
}
