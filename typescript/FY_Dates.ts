function main(workbook: ExcelScript.Workbook) {
  let today = new Date();
  let currentYear = today.getFullYear();

  // Adjusted logic: If it's May (month 4) or later, we're preparing for the next FY
  let fiscalYearStart = today.getMonth() >= 4 ? currentYear + 1 : currentYear;

  const monthMap: {[key: string]: number} = {
    "Jul": 6, "Aug": 7, "Sep": 8, "Oct": 9, "Nov": 10, "Dec": 11,
    "Jan": 0, "Feb": 1, "Mar": 2, "Apr": 3, "May": 4, "Jun": 5
  };

  workbook.getWorksheets().forEach(sheet => {
    let sheetName = sheet.getName();
    if (monthMap.hasOwnProperty(sheetName)) {
      let monthIndex = monthMap[sheetName];
      // Months July–Dec are in the fiscalYearStart
      // Months Jan–Jun are in fiscalYearStart + 1
      let year = (monthIndex >= 6) ? fiscalYearStart : fiscalYearStart + 1;
      let newDate = new Date(year, monthIndex, 1);
      sheet.getRange("A3").setValue(newDate);
    }
  });
}
