<html>
<head>
<style type="text/css">
body
{ 
#  background-image:url('juniper.png');
  background-repeat:no-repeat;
  background-attachment:fixed;
  background-position:center;
}
div#container{width:1000px}
div#header {background-color:#99bbbb;width:1000px}
div#daily {background-color:#ffffff; width:1000px; position:absolute; top:20%}
div#historical {background-color:#EEEEEE; height: 50px;width:1000px; text-align:center; }
div#footer {background-color:#99bbbb; clear:both; text-align:center;}
.center {align: center}
.hdid{color:#ffffff;background-color:#5F9EA0;width:1000px;position:absolute; top:10%;font-family:"Trebuchet MS", Arial, Helvetica, sans-serif;};
.hisid{background-color:#EEEEEE;width:1000px;text-align:left;position:absolute; top:80%};
p#summarypage { position:absolute; top:95%}
#ip, #file
  {
  font-family:"Trebuchet MS", Arial, Helvetica, sans-serif;
  width:100%;
  border-collapse:collapse;
  }

#ip td, #ip th, #file td, #file th
  {
  font-size:1em;
#  border:1px solid #98bf21;
  border:1px solid #5F9EA0;
  padding:3px 7px 2px 7px;
  }

#ip th, #file th 
  {
  font-size:1.1em;
  text-align:left;
  padding-top:5px;
  padding-bottom:4px;
#  background-color:#A7C942;
  background-color:#5F9EA0;
  color:#ffffff;
  }
#ip tr.alt 
  {
   color:#000000;
   background-color:#C0C0C0;
   }
</style>
</head>

<body>
<img src="juniper.png" class="center"/>
<h1 class=hdid>UTM Akamai Server Access Statistics Daily status</h1>
<div id="daily">
<div id="daily1">
<?php
function test_input($data) {
   $data = trim($data);
   $data = stripslashes($data);
   $data = htmlspecialchars($data);
   return $data;
}
#    $date = date("Y-m-d");
    $myfile = fopen("latest_ip_stats.txt", "r") or die("Unable to open file!");
    $line = fgets($myfile);
    $date = $line;
    echo "<h4>Latest IP Statistics $line by AV type </h4>"; 
     echo "<table id=ip border=1 width=600 cellpadding=10>";
     echo "<tr>";
     echo "<th>AV Type</th>";
     echo "<th>Platform Type</th>";
     echo "<th>Access Number by Unique IP</th>";
     echo "</tr>";   
#    while(!feof($myfile)) {
    $sum=0;
    for ($x=0; $x<7; $x++) {
     $line = fgets($myfile);
     list($type, $platform, $number) =  preg_split('/[\n\r\t\s]+/i', $line);
     $sum += $number;
             echo "<tr>";
     if($x==0) {
     echo "<td rowspan=8>" . $type  . "</td>";
     }  
             echo "<td>" . $platform  . "</td>";
             echo "<td>" . $number . "</td>";
             echo "</tr>";
     }
     echo "<tr class=alt>";
 #    echo "<td> "."</td>";
     echo "<td>" . "KAV Total:" . "</td>";
     echo "<td>" . $sum . "&nbsp" . "&nbsp" . "&nbsp" . "&nbsp" . "<a href='kav_detail.php?date=$date' font-size:80px>Learn IP and FQDN detail</a>" . "</td>";
     echo "</tr>";
     $sum=0;     
     for ($x=0; $x<5; $x++) {                                                                                                      
         $line = fgets($myfile); 
         list($type, $platform, $number) =  preg_split('/[\n\r\t\s]+/i', $line);
         $sum += $number;  
     if($x==0) {
	 echo "<td rowspan=6>" . $type  . "</td>";
     } 
      	 echo "<td>" . $platform  . "</td>";
         echo "<td>" . $number . "</td>";
         echo "</tr>";
     }
     echo "<tr class=alt>";
#     echo "<td>" ."</td>";
     echo "<td>" . "EAV Total:" . "</td>";
     echo "<td>" . "$sum" . "&nbsp" . "&nbsp" . "&nbsp". "&nbsp" . "&nbsp" . "<a href='eav_detail.php?date=$date' font-size:80px>Learn IP and FQDN detail</a>" .  "</td>";       
     echo "</tr>";
     $line = fgets($myfile);
     list($type, $platform, $number) =  preg_split('/[\n\r\t\s]+/i', $line);
     echo "<tr>";
     echo "<td>" . $type  . "</td>";
     echo "<td>" . $platform  . "</td>";
     echo "<td>" . $number . "&nbsp" . "&nbsp" . "&nbsp". "&nbsp" . "&nbsp" . "&nbsp" ."<a href='sav_detail.php?date=$date' font-size:80px>Learn IP and FQDN detail</a>" . "</td>";
     echo "</tr>";
     $sum=0;
     for ($x=0; $x<2; $x++) {                                                                                                      
     $line = fgets($myfile); 
     list($type, $platform, $number) =  preg_split('/[\n\r\t\s]+/i', $line);
             $sum += $number; 
     if($x==0) {
         echo "<td rowspan=3>" . $type  . "</td>";
     }     
         echo "<td>" . $platform  . "</td>";
         echo "<td>" . $number . "</td>";
         echo "</tr>";
     }
     echo "<tr class=alt>";
#     echo "<td>" ."</td>";
     echo "<td>" . "KAV_Engine Total:" . "</td>";
     echo "<td>" . "$sum" . "&nbsp" . "&nbsp" . "&nbsp" . "&nbsp". "&nbsp" ."<a href='kav_engine_detail.php?date=$date' font-size:80px>Learn IP and FQDN detail</a>" .  "</td>";       
     echo "</tr>";
     echo "</table>";
   #    }
?>
</div>
<div id="daily2">
<h4>Downloaded File Statistics by AV type for <?php  $myfile = fopen("latest_ip_stats.txt", "r") or die("Unable to open file!");
$line = fgets($myfile); echo "$line";?> </h4> 
<table id="file" border="1" width="400" cellpadding="10">
<tr>
  <th>AV Type</th>
  <th>Downloaded File</th>
  <th>Downloaded Number</th>
</tr>
<?php
$myfile = fopen("latest_stats.txt", "r") or die("Unable to open file!");
#while(!feof($myfile)) {
     $i = 0;
     while($i < 6)  { 
     echo "<tr>";      
     $i += 1;
     $line = fgets($myfile);    
     if ($line != null && $i > 1) {
     #     list($type, $file, $number) = explode("", $line); 	 
          list($type, $file, $number) =  preg_split('/[\n\r\t\s]+/i', $line);  
	     echo "<td>" . $type . "<br>" . "</td>";
             echo "<td>" . $file . "<br>" . "</td>";
	     echo "<td>" . $number . "<br>" . "</td>";
	     echo "</tr>";      
     }    
}
?>
</table>
</div>
<div id="historical">
<h1 class=hisid style="background-color:#EEEEEE;text-align:left;width:1000px">Historical Data</h1>
<form action="result.php" method="post" style="text-align:left;">
Date(follow format like 2008-08-08):<input type="text" name="date"><br>
<input type="submit" value="Query">
</form>
</div>
</div>
</body>
</html>
