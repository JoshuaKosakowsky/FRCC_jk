function main(workbook: ExcelScript.Workbook) {
	let selectedSheet = workbook.getActiveWorksheet();
	// Paste to range A:A on selectedSheet from range A:A on selectedSheet
	selectedSheet.getRange("A:A").copyFrom(selectedSheet.getRange("A:A"), ExcelScript.RangeCopyType.values, false, false);
	// Paste to range A1 on selectedSheet from range A1:G3 on selectedSheet
	selectedSheet.getRange("A1").copyFrom(selectedSheet.getRange("A1:G3"), ExcelScript.RangeCopyType.values, false, false);
	let aug = workbook.getWorksheet("Aug");
	// Paste to range A:A on aug from range A:A on aug
	aug.getRange("A:A").copyFrom(aug.getRange("A:A"), ExcelScript.RangeCopyType.values, false, false);
	// Paste to range A1 on aug from range A1:G3 on aug
	aug.getRange("A1").copyFrom(aug.getRange("A1:G3"), ExcelScript.RangeCopyType.values, false, false);
	let sep = workbook.getWorksheet("Sep");
	// Paste to range A:A on sep from range A:A on sep
	sep.getRange("A:A").copyFrom(sep.getRange("A:A"), ExcelScript.RangeCopyType.values, false, false);
	// Paste to range A1 on sep from range A1:G3 on sep
	sep.getRange("A1").copyFrom(sep.getRange("A1:G3"), ExcelScript.RangeCopyType.values, false, false);
	let oct = workbook.getWorksheet("Oct");
	// Paste to range A:A on oct from range A:A on oct
	oct.getRange("A:A").copyFrom(oct.getRange("A:A"), ExcelScript.RangeCopyType.values, false, false);
	// Paste to range A1 on oct from range A1:G3 on oct
	oct.getRange("A1").copyFrom(oct.getRange("A1:G3"), ExcelScript.RangeCopyType.values, false, false);
	let nov = workbook.getWorksheet("Nov");
	// Paste to range A:A on nov from range A:A on nov
	nov.getRange("A:A").copyFrom(nov.getRange("A:A"), ExcelScript.RangeCopyType.values, false, false);
	// Paste to range A1 on nov from range A1:G3 on nov
	nov.getRange("A1").copyFrom(nov.getRange("A1:G3"), ExcelScript.RangeCopyType.values, false, false);
	let dec = workbook.getWorksheet("Dec");
	// Paste to range A:A on dec from range A:A on dec
	dec.getRange("A:A").copyFrom(dec.getRange("A:A"), ExcelScript.RangeCopyType.values, false, false);
	// Paste to range A1 on dec from range A1:G3 on dec
	dec.getRange("A1").copyFrom(dec.getRange("A1:G3"), ExcelScript.RangeCopyType.values, false, false);
	let jan = workbook.getWorksheet("Jan");
	// Paste to range A:A on jan from range A:A on jan
	jan.getRange("A:A").copyFrom(jan.getRange("A:A"), ExcelScript.RangeCopyType.values, false, false);
	// Paste to range A1 on jan from range A1:G3 on jan
	jan.getRange("A1").copyFrom(jan.getRange("A1:G3"), ExcelScript.RangeCopyType.values, false, false);
	let feb = workbook.getWorksheet("Feb");
	// Paste to range A:A on feb from range A:A on feb
	feb.getRange("A:A").copyFrom(feb.getRange("A:A"), ExcelScript.RangeCopyType.values, false, false);
	// Paste to range A1 on feb from range A1:G3 on feb
	feb.getRange("A1").copyFrom(feb.getRange("A1:G3"), ExcelScript.RangeCopyType.values, false, false);
	let mar = workbook.getWorksheet("Mar");
	// Paste to range A:A on mar from range A:A on mar
	mar.getRange("A:A").copyFrom(mar.getRange("A:A"), ExcelScript.RangeCopyType.values, false, false);
	// Paste to range A1 on mar from range A1:G3 on mar
	mar.getRange("A1").copyFrom(mar.getRange("A1:G3"), ExcelScript.RangeCopyType.values, false, false);
	let apr = workbook.getWorksheet("Apr");
	// Paste to range A:A on apr from range A:A on apr
	apr.getRange("A:A").copyFrom(apr.getRange("A:A"), ExcelScript.RangeCopyType.values, false, false);
	// Paste to range A1 on apr from range A1:G3 on apr
	apr.getRange("A1").copyFrom(apr.getRange("A1:G3"), ExcelScript.RangeCopyType.values, false, false);
	let may = workbook.getWorksheet("May");
	// Paste to range A:A on may from range A:A on may
	may.getRange("A:A").copyFrom(may.getRange("A:A"), ExcelScript.RangeCopyType.values, false, false);
	// Paste to range A1 on may from range A1:G3 on may
	may.getRange("A1").copyFrom(may.getRange("A1:G3"), ExcelScript.RangeCopyType.values, false, false);
	let jun = workbook.getWorksheet("Jun");
	// Paste to range A:A on jun from range A:A on jun
	jun.getRange("A:A").copyFrom(jun.getRange("A:A"), ExcelScript.RangeCopyType.values, false, false);
	// Paste to range A1 on jun from range A1:G3 on jun
	jun.getRange("A1").copyFrom(jun.getRange("A1:G3"), ExcelScript.RangeCopyType.values, false, false);
}
