function main(workbook: ExcelScript.Workbook) {
	let selectedSheet = workbook.getActiveWorksheet();
	// Unmerge all cells on selectedSheet
	selectedSheet.getRange().unmerge();
	// Delete range 1:2 on selectedSheet
	selectedSheet.getRange("1:2").delete(ExcelScript.DeleteShiftDirection.up);
	// Replace " *" with "" on selectedSheet
	selectedSheet.replaceAll(" *", "", {completeMatch: false, matchCase: false});
	// Replace "," with "" on selectedSheet
	selectedSheet.replaceAll(",", "", {completeMatch: false, matchCase: false});
	// Replace "\"C\"" with "Credit" on selectedSheet
	selectedSheet.replaceAll("\"C\"", "Credit", {completeMatch: false, matchCase: false});
	// Replace "\"D\"" with "Dedit" on selectedSheet
	selectedSheet.replaceAll("\"D\"", "Dedit", {completeMatch: false, matchCase: false});
	// Set range H2 on selectedSheet
	selectedSheet.getRange("H2").setFormulaLocal("=IF(G2=\"Credit\",-F2,F2)");
	// Auto fill range
	selectedSheet.getRange("H2").autoFill();
	// Paste to range F2 on selectedSheet from range H2:H6556 on selectedSheet
	selectedSheet.getRange("F2").copyFrom(selectedSheet.getRange("H2:H6556"), ExcelScript.RangeCopyType.values, false, false);
	// Delete range H:H on selectedSheet
	selectedSheet.getRange("H:H").delete(ExcelScript.DeleteShiftDirection.left);
	// Set format for range F:F on selectedSheet
	selectedSheet.getRange("F:F").setNumberFormatLocal("_($* #,##0.00_);_($* (#,##0.00);_($* \"-\"??_);_(@_)");
	// Set format for range B:B on selectedSheet
	selectedSheet.getRange("B:B").setNumberFormatLocal("m/d/yyyy");
	// Toggle auto filter on selectedSheet
	selectedSheet.getAutoFilter().apply(selectedSheet.getRange("A1:G1"));
	// Auto fit the columns of range A:G on selectedSheet
	selectedSheet.getRange("A:G").getFormat().autofitColumns();
}
