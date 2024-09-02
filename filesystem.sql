CREATE TABLE FileSystem (
    NodeID INT PRIMARY KEY,
    NodeName VARCHAR(255),
    ParentID INT,
    SizeBytes INT
);
INSERT INTO FileSystem (NodeID, NodeName, ParentID, SizeBytes) VALUES
(1, 'Documents', NULL, NULL),
(2, 'Pictures', NULL, NULL),
(3, 'File1.txt', 1, 500),
(4, 'Folder1', 1, NULL),
(5, 'Image.jpg', 2, 1200),
(6, 'Subfolder1', 4, NULL),
(7, 'File2.txt', 4, 750),
(8, 'File3.txt', 6, 300),
(9, 'Folder2', 1, NULL),
(10, 'File4.txt', 9, 250);

WITH RECURSIVE SizeCalculation AS (
    -- Start with all nodes that have a size
    SELECT 
        NodeID, 
        NodeName, 
        ParentID, 
        COALESCE(SizeBytes, 0) AS TotalSize
    FROM FileSystem
    WHERE SizeBytes IS NOT NULL

    UNION ALL

    -- Recursively add sizes of children to their parents
    SELECT 
        fs.NodeID, 
        fs.NodeName, 
        fs.ParentID, 
        sc.TotalSize
    FROM FileSystem fs
    INNER JOIN SizeCalculation sc ON fs.NodeID = sc.ParentID
)
SELECT
    NodeID,
    NodeName,
    SUM(TotalSize) AS SizeBytes
FROM SizeCalculation
GROUP BY NodeID, NodeName
ORDER BY NodeID;
