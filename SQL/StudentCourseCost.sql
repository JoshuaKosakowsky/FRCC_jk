USE IRNew
GO
SELECT term, crn, crs_num, section, camp_code, title, id, stu_credits, stu_credits*393.80 AS cost_estimate
FROM dbo.vCourseStudent
WHERE TERM = '202530'
ORDER BY id DESC;
