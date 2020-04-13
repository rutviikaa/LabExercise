CREATE PROCEDURE Employees.GetSalary
@month int
AS
SET NOCOUNT ON;
BEGIN
(SELECT e.EmployeeName, s.Salary FROM Employees AS e INNER JOIN Salary AS s ON e.EmployeeId = s.EmployeeId WHERE s.Month = @month) FOR JSON PATH;
END