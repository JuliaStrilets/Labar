class MySQLConnectionUtil
{
 public static function getConnection()
 {
 $servername = 'localhost';
 $username = $_SESSION['username'];
 $password = $_SESSION['password'];
 $database = 'delivery';
 $conn = mysqli_connect($servername, $username, $password, $database);
 if (!$conn)
 {
 throw new Exception(mysqli_connect_error());
 }
 return $conn;
 }
}
