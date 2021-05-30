require_once($_SERVER['DOCUMENT_ROOT'].'/Delivery/App/Domain/Contract.php');
require_once($_SERVER['DOCUMENT_ROOT'].'/Delivery/App/Util/MySQLConnectionUtil.php');
require_once('ContractRepositoryInterface.php');
class MySQLContractRepository implements ContractRepositoryInterface
{
 public function getContractList()
 {
 $conn = MySQLConnectionUtil::getConnection();
 $contracts = array();
 $query = 'SELECT number, agreed, supplier, title, note FROM contract';
 $result = mysqli_query($conn, $query);
 while ($row = mysqli_fetch_assoc($result))
 {
 $contract = new Contract($row['number'], $row['agreed'], $row['supplier'],
 $row['title'], $row['note']);
 array_push($contracts, $contract);
 }
 mysqli_close($conn);
 return $contracts;
 }
 public function getContractByNumber($number)
 {
 $conn = MySQLConnectionUtil::getConnection();
 $contract = NULL;
 $query = "SELECT number, agreed, supplier, title, note FROM contract
 WHERE number = {$number}";
 $result = mysqli_query($conn, $query);
 while ($row = mysqli_fetch_assoc($result))
 {
 $contract = new Contract($row['number'], $row['agreed'], $row['supplier'],
 $row['title'], $row['note']);
 break;
 }
 mysqli_close($conn);
 if ($contract == NULL)
 {
 throw new Exception("Contract with number {$number} doesn't exist!");
 }
 return $contract;
 }
 public function create($contract)
 {
 $conn = MySQLConnectionUtil::getConnection();
 $number = $contract->getNumber();
 $agreed = $contract->getAgreed();
 $supplier = $contract->getSupplier();
 $title = $contract->getTitle();
 $note = $contract->getNote();
 $query = "INSERT INTO contract(number, agreed, supplier, title, note)
 VALUES ({$number}, '{$agreed}', {$supplier}, '{$title}', '{$note}')";
 $result = mysqli_query($conn, $query);
 if (!$result)
 {
 throw new Exception(mysqli_error($conn));
 }
 mysqli_close($conn);
 }
 public function update($contract)
 {
 $conn = MySQLConnectionUtil::getConnection();
 $number = $contract->getNumber();
 $agreed = $contract->getAgreed();
 $supplier = $contract->getSupplier();
 $title = $contract->getTitle();
 $note = $contract->getNote();
 $query = "UPDATE contract SET agreed = '{$agreed}', supplier = {$supplier},
 title = '{$title}', note = '{$note}' WHERE number = {$number}";
 $result = mysqli_query($conn, $query);
 if (!$result)
 {
 throw new Exception(mysqli_error($conn));
 }
 mysqli_close($conn);
 }
 public function delete($number)
 {
 $conn = MySQLConnectionUtil::getConnection();
 $query = "DELETE FROM contract WHERE number = {$number}";
 $result = mysqli_query($conn, $query);
 if (!$result)
 {
 throw new Exception(mysqli_error($conn));
 }
 mysqli_close($conn);
 }
}
