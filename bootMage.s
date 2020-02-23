# Boot Mage
# wish list: next dungeon, end-game statistics

python
import re
from os import system, name
import time #remove later

def clear():   
  # for windows 
  if name == 'nt': 
    _ = system('cls') 
  # for mac and linux os.name is 'posix'
  else: 
    _ = system('clear') 

def pex(arg):
  try:
    return gdb.execute(arg, to_string=True)
  except:
    return("error")

i = 0
gold = 0
dungeon_number = '?'
# Item Totals
total_gold = 0
total_traps = 0
total_food = 0
total_armor = 0
total_swords = 0
total_enemies = 0
total_steps = 0
grand_total_gold = 0
grand_total_traps = 0
grand_total_food = 0
grand_total_armor = 0
grand_total_swords = 0
grand_total_enemies = 0
damaged_by = ''

# Friendly enemy names for each enemy (similar to Rogue/NetHack)
enemynames = {'A': 'ANT','B': 'BAT','C': 'COCKATRICE','D': 'DRAGON','E': 'EYE','F': 'FELINE',
  'G': 'GREMLIN','H': 'HOBBIT','I': 'IMP','J': 'JELLY','K': 'KOBOLD','L': 'LEPRECHAUN',
  'M': 'MUMMY','N': 'NYMPH','O': 'ORC','P': 'PIERCER','Q': 'QUADRUPED','R': 'RODENT','S': 'SPIDER',
  'T': 'TROLL','U': 'UMBER HULK','V': 'VAMPIRE','W': 'WORM','X': 'XORN','Y': 'YETI','Z': 'ZOMBIE'}



# Dungeon Metadata
# [byte identifier, dungeon number/exit corner/tip,gold,traps,food,armor,swords,enemies]
dungeons =[['63','1','NW','Tip: Dng 31  3♣ 0♦',2,2,3,3,2,9,'SW'],
  ['64','2','NW','Tip: Dng 72  2♣ 2♦',2,1,2,2,2,5,'SW'],
  ['5f','3','SE','Tip: Dng 51  2♣ 1♦',2,1,2,2,2,7,'NW'],
  ['78','4','NW','Tip: Dng 31  2♣ 1♦',1,1,2,1,1,5,'NW'],
  ['fb','5','NW','Tip: Dng 63  2♣ 1♦',2,2,2,2,2,8,'SW'],
  ['6c','6','NW','Tip: Dng 72  2♣ 2♦',2,1,2,2,2,5,'SW'],
  ['37','7','SW','Tip: Dng 15  2♣ 1♦',1,1,2,2,1,4,'SW'],
  ['40','8','NE','Tip: Dng 89  3♣ 2♦',1,2,3,3,2,10,'NW'],
  ['13','9','NW','Tip: Dng 63  2♣ 1♦',2,2,2,2,2,9,'SW'],
  ['f4','10','NW','Tip: Dng 28  0♣ 0♦',1,1,2,2,1,5,'SW'],
  ['8f','11','SW','Dng 30,31,33,35,37',2,1,2,2,2,9,'SW'],
  ['88','12','SW','Tip: Dng 13  0♣ 1♦',1,1,2,2,1,4,'NW'],
  ['ab','13','SE','Tip: Dng 51  3♣ 0♦',3,2,3,3,3,13,'NW'],
  ['fc','14','NW','Dng 72,77,71,75   ',2,1,2,2,2,5,'SW'],
  ['67','15','SE','Tip: Dng 59  3♣ 0♦',3,3,3,2,3,9,'NW'],
  ['50','16','NW','Dng 1,2,3,4,6,3,5 ',2,1,2,1,2,7,'NW'],
  ['c3','17','NW','Tip: Dng 72  1♣ 3♦',2,1,1,1,2,5,'SW'],
  ['84','18','NW','Tip: Dng 72  1♣ 3♦',2,1,1,1,2,5,'SW'],
  ['bf','19','NW','Tip: Dng 1   1♣ 0♦',2,1,1,1,2,6,'SW'],
  ['98','20','SE','Tip: Dng 67  1♣ 2♦',2,1,1,1,2,8,'SW'],
  ['5b','21','SW','Dng 19,22,15,23,20',2,2,2,2,2,9,'NW'],
  ['8c','22','NW','Tip: Dng 1   1♣ 0♦',2,1,1,1,2,5,'SW'],
  ['97','23','NW','Tip: Dng 61  1♣ 0♦',2,2,1,1,2,9,'SW'],
  ['60','24','NW','Tip: Dng 28  0♣ 0♦',1,1,1,1,1,5,'SW'],
  ['73','25','SW','Tip: Dng 31  2♣ 1♦',3,2,2,2,3,14,'NW'],
  ['14','26','NW','Tip: Dng 61  1♣ 0♦',2,2,1,1,2,8,'SW'],
  ['ef','27','NW','Tip: Dng 61  1♣ 0♦',2,2,1,1,2,8,'SW'],
  ['a8','28','NW','Tip: Dng 1   1♣ 0♦',2,1,1,1,2,5,'SW'],
  ['0b','29','NW','Tip: Dng 1   0♣ 1♦',2,1,1,1,2,6,'SW'],
  ['1c','30','NW','Tip: Dng 1   1♣ 0♦',2,1,1,1,2,6,'SW'],
  ['c7','31','NW','Tip: Dng 1   1♣ 0♦',2,1,1,1,2,6,'SW'],
  ['70','32','SW','Dng 30,31,33,35,37',2,2,2,2,2,9,'NW'],
  ['23','33','NW','Tip: Dng 31  2♣ 1♦',2,2,2,2,2,10,'SW'],
  ['a4','34','SE','Tip: Dng 51  1♣ 2♦',2,1,1,1,2,8,'NW'],
  ['1f','35','SE','Tip: Dng 67  2♣ 1♦',3,2,2,2,3,12,'NW'],
  ['b8','36','SE','Tip: Dng 51  1♣ 2♦',2,1,1,1,2,6,'NW'],
  ['bb','37','NW','Tip: Dng 38  2♣ 4♦',2,2,2,2,2,9,'SW'],
  ['ac','38','NW','Tip: Dng 1   1♣ 0♦',2,1,1,1,2,5,'SW'],
  ['f7','39','SW','Tip: Dng 15  2♣ 1♦',2,2,2,2,2,8,'NW'],
  ['80','40','NW','Tip: Dng 61  1♣ 0♦',2,1,1,1,2,7,'SW'],
  ['d3','41','SW','Tip: Dng 15  2♣ 1♦',2,2,2,2,2,8,'NW'],
  ['34','42','SE','Tip: Dng 51  1♣ 2♦',2,1,1,1,2,6,'NW'],
  ['4f','43','NW','Tip: Dng 31  2♣ 1♦',2,2,2,2,2,9,'SW'],
  ['c8','44','NW','Tip: Dng 61  1♣ 0♦',2,2,1,1,2,7,'SW'],
  ['6b','45','NW','Tip: Dng 72  2♣ 2♦',3,2,2,2,3,9,'SW'],
  ['3c','46','NW','Tip: Dng 61  1♣ 0♦',2,2,1,1,2,8,'SW'],
  ['27','47','NW','Tip: Dng 63  2♣ 1♦',3,3,2,2,3,12,'SW'],
  ['90','48','SW','Tip: Dng 15  2♣ 1♦',2,2,2,2,2,8,'NW'],
  ['83','49','SW','Tip: Dng 15  1♣ 2♦',2,2,2,2,2,8,'NW'],
  ['c4','50','NW','Tip: Dng 72  1♣ 3♦',2,1,1,1,2,4,'SW'],
  ['7f','51','NW','Tip: Dng 31  2♣ 1♦',2,2,2,2,2,8,'SW'],
  ['d8','52','NW','Tip: Dng 38  2♣ 4♦',1,2,2,2,2,9,'SW'],
  ['1b','53','NW','Tip: Dng 61  1♣ 0♦',2,2,1,1,2,8,'SW'],
  ['cc','54','SW','Tip: Dng 15  2♣ 1♦',2,2,2,2,2,8,'NW'],
  ['57','55','SW','Tip: Dng 15  2♣ 1♦',2,2,2,2,2,8,'NW'],
  ['a0','56','SE','Tip: Dng 61  1♣ 2♦',2,1,1,1,2,6,'NW'],
  ['33','57','NW','Tip: Dng 33  1♣ 0♦',2,2,2,2,2,9,'SW'],
  ['54','58','NW','Tip: Dng 1   0♣ 1♦',2,1,1,1,2,5,'SW'],
  ['af','59','NW','Tip: Dng 1   0♣ 1♦',2,1,1,1,2,5,'SW'],
  ['e8','60','SW','Dng 30,31,33,35,37',2,1,1,1,2,8,'NW'],
  ['cb','61','NW','Tip: Dng 31  2♣ 1♦',2,2,2,2,2,8,'SW'],
  ['5c','62','NW','Tip: Dng 61  1♣ 0♦',2,2,2,2,2,8,'SW'],
  ['87','63','NW','Tip: Dng 31  2♣ 1♦',2,2,2,2,2,9,'SW'],
  ['b0','64','NW','Tip: Dng 31  2♣ 1♦',2,2,2,2,1,8,'SW'],
  ['e3','65','NW','Tip: Dng 63  2♣ 1♦',3,3,2,2,3,12,'SW'],
  ['e4','66','NW','Tip: Dng 31  2♣ 1♦',2,2,2,2,1,8,'SW'],
  ['df','67','NW','Tip: Dng 1   1♣ 0♦',3,2,2,2,3,9,'SW'],
  ['f8','68','NW','Dng 30,31,33,35,37',2,2,2,2,2,9,'SW'],
  ['7b','69','SE','Tip: Dng 58  2♣ 0♦',3,2,2,2,3,9,'NW'],
  ['ec','70','SE','Tip: Dng 58  2♣ 0♦',2,2,2,2,3,9,'NW'],
  ['b7','71','NW','Tip: Dng 31  2♣ 1♦',1,2,2,2,2,8,'SW'],
  ['c0','72','NW','Tip: Dng 1   1♣ 0♦',1,1,1,1,2,5,'SW'],
  ['93','73','NW','Tip: Dng 61  1♣ 0♦',1,2,1,1,2,8,'SW'],
  ['74','74','NW','Dng 30,31,33,35,37',1,2,2,2,1,9,'SW'],
  ['0f','75','SE','Tip: Dng 67  2♣ 1♦',2,2,2,2,2,12,'NW'],
  ['08','76','SE','Dng 51,58,52,53,57',1,1,1,1,1,6,'NW'],
  ['2b','77','NW','Tip: Dng 1   1♣ 0♦',2,2,2,2,2,10,'SW'],
  ['7c','78','SE','Dng 51,58,52,53,57',1,1,1,1,1,6,'NW'],
  ['e7','79','NW','Tip: Dng 72  2♣ 2♦',2,2,2,2,2,9,'SW'],
  ['d0','80','SW','Dng 30,31,33,35,37',1,1,1,1,1,7,'NW'],
  ['43','81','NW','Tip: Dng 31  2♣ 1♦',1,2,2,2,1,7,'SW'],
  ['04','82','NW','Tip: Dng 61  1♣ 0♦',1,2,1,1,1,7,'SW'],
  ['3f','83','NW','Tip: Dng 31  2♣ 1♦',1,2,2,2,1,8,'SW'],
  ['18','84','SW','Dng 30,31,33,35,37',1,1,1,1,1,6,'NW'],
  ['db','85','NW','Tip: Dng 72  2♣ 2♦',2,2,2,2,2,8,'SW'],
  ['0c','86','SW','Tip: Dng 15  2♣ 1♦',1,2,2,2,1,7,'NW'],
  ['17','87','NW','Tip: Dng 63  2♣ 1♦',2,3,2,2,2,11,'SW'],
  ['e0','88','SW','Tip: Dng 15  1♣ 2♦',1,2,2,2,1,7,'NW'],
  ['f3','89','SE','Tip: Dng 67  2♣ 1♦',2,2,2,2,2,8,'NW'],
  ['94','90','SW','Dng 30,31,33,35,37',1,1,1,1,1,6,'NW'],
  ['6f','91','NW','Tip: Dng 38  1♣ 0♦',1,3,3,3,2,13,'SW'],
  ['28','92','SW','Tip: Dng 101 1♣ 0♦',2,2,2,2,2,8,'NW'],
  ['8b','93','NW','Tip: Dng 72  2♣ 2♦',2,2,2,2,2,7,'SW'],
  ['9c','94','NW','Dng 63,64,66,67,62',1,2,1,1,1,7,'SW'],
  ['47','95','SW','Tip: Dng 15  1♣ 2♦',1,2,2,2,1,7,'NW'],
  ['f0','96','NW','Tip: Dng 31  2♣ 1♦',1,2,2,2,1,8,'SW'],
  ['a3','97','NW','Tip: Dng 1   1♣ 0♦',2,2,2,2,2,9,'SW'],
  ['24','98','NW','Tip: Dng 72  2♣ 2♦',2,2,2,2,2,7,'SW'],
  ['9f','99','SW','Dng 30,31,33,35,37',2,2,2,2,2,12,'NW'],
  ['38','100','NW','Tip: Dng 61  1♣ 0♦',1,2,1,1,1,7,'SW'],
  ['3b','101','NW','Tip: Dng 31  3♣ 0♦',2,3,3,3,2,11,'SW'],
  ['2c','102','NE','Tip: Dng 128 2♣ 1♦',1,2,2,2,2,10,'SW'],
  ['77','103','NW','Tip: Dng 31  2♣ 1♦',1,2,2,2,1,6,'SW'],
  ['00','104','NW','Tip: Dng 72  2♣ 2♦',2,1,2,2,2,6,'SW'],
  ['53','105','NW','Tip: Dng 63  2♣ 1♦',2,3,2,2,2,11,'SW'],
  ['b4','106','SW','Tip: Dng 101 1♣ 0♦',2,2,2,2,2,7,'NW'],
  ['cf','107','NW','Tip: Dng 1   1♣ 0♦',2,2,2,2,2,7,'SW'],
  ['48','108','NW','Tip: Dng 61  1♣ 0♦',1,2,1,1,1,4,'SW'],
  ['eb','109','NW','Tip: Dng 31  3♣ 0♦',2,3,3,3,2,10,'SW'],
  ['bc','110','NW','Tip: Dng 72  2♣ 2♦',2,2,2,2,2,6,'SW'],
  ['a7','111','SW','Tip: Dng 103 3♣ 0♦',3,3,3,3,2,10,'NW'],
  ['10','112','SW','Tip: Dng 101 1♣ 0♦',2,2,2,2,2,5,'NW'],
  ['03','113','NW','Tip: Dng 72  2♣ 2♦',2,2,2,2,2,4,'SW'],
  ['44','114','SW','Dng 19,22,15,23,20',1,1,1,2,1,5,'NW'],
  ['ff','115','NW','Tip: Dng 72  2♣ 2♦',2,2,2,2,2,5,'SW'],
  ['58','116','SW','Tip: Dng 15  0♣ 3♦',1,2,2,2,1,4,'NW'],
  ['9b','117','SW','Tip: Dng 15  3♣ 0♦',2,3,3,3,2,9,'NW'],
  ['4c','118','NW','Tip: Dng 31  2♣ 1♦',1,2,2,2,1,5,'SW'],
  ['d7','119','NW','Tip: Dng 72  2♣ 2♦',2,2,2,2,2,5,'SW'],
  ['20','120','SW','Tip: Dng 109 2♣ 1♦',2,1,2,2,2,5,'NW'],
  ['b3','121','NW','Tip: Dng 38  3♣ 3♦',2,3,3,2,2,9,'SW'],
  ['d4','122','SW','Tip: Dng 15  1♣ 2♦',1,2,2,2,1,4,'NW'],
  ['2f','123','NW','Tip: Dng 72  3♣ 1♦',3,3,3,3,3,9,'SW'],
  ['68','124','SE','Tip: Dng 72  2♣ 1♦',2,2,2,2,2,8,'NW'],
  ['4b','125','NW','Tip: Dng 107 2♣ 2♦',2,1,2,2,2,5,'SW'],
  ['dc','126','NW','Tip: Dng 31  1♣ 2♦',1,1,1,2,1,5,'SW'],
  ['07','127','NW','Tip: Dng 64  2♣ 1♦',2,2,2,2,2,8,'SW'],
  ['30','128','NW','Tip: Dng 1   1♣ 0♦',2,1,2,2,2,5,'SW'],['01','01h','NW','Tip: Dng 67  4♣ 1♦',4,4,4,4,4,19],
  ['4e','4eh','SW','Tip: Dng 118 4♣ 0♦',5,5,4,4,5,18],['cd','cdh','NW','Tip: Dng 77  3♣ 0♦',4,4,4,4,4,19],
  ['52','52h','NE','Tip: Dng 107 3♣ 2♦',4,4,3,3,4,16],['b9','b9h','SW','Tip: Dng 72  3♣ 3♦',4,3,3,3,3,15],
  ['b6','b6h','NE','Tip: Dng 38  3♣ 1♦',4,4,3,3,4,17],['c5','c5h','NW','Tip: Dng 67  4♣ 1♦',4,4,4,4,4,19],
  ['7a','7ah','NW','Tip: Dng 67  4♣ 1♦',4,4,4,4,3,18],['f1','f1h','NE','Tip: Dng 77  4♣ 3♦',5,5,4,4,5,17],
  ['9e','9eh','NE','Tip: Dng 38  3♣ 1♦',4,4,3,3,4,17],['3d','3dh','NW','Tip: Dng 67  4♣ 1♦',4,4,4,4,4,18],
  ['22','22h','NE','Tip: Dng 128 2♣ 0♦',3,4,3,3,3,18],['a9','a9h','NE','Tip: Dng 38  2♣ 2♦',3,4,2,3,4,16],
  ['06','06h','NW','Tip: Dng 77  3♣ 0♦',3,4,4,4,4,19],['35','35h','SE','Tip: Dng 38  4♣ 0♦',3,4,4,4,4,20],
  ['4a','4ah','SE','Tip: Dng 51  4♣ 1♦',3,3,4,4,4,19],['e1','e1h','NW','Tip: Dng 67  4♣ 1♦',3,3,4,4,4,19],
  ['ee','eeh','NE','Tip: Dng 38  3♣ 1♦',3,4,3,3,4,17],['ad','adh','NE','Tip: Dng 107 1♣ 0♦',3,3,3,3,4,15],
  ['f2','f2h','NW','Tip: Dng 67  4♣ 1♦',3,4,4,4,4,19],['99','99h','NE','Tip: Dng 128 2♣ 0♦',3,3,3,3,4,18],
  ['56','56h','SE','Tip: Dng 38  4♣ 0♦',4,4,4,4,4,20],['a5','a5h','NW','Tip: Dng 67  4♣ 1♦',3,4,4,4,4,19],
  ['1a','1ah','SE','Tip: Dng 51  4♣ 1♦',3,4,4,4,4,20],['d1','d1h','SW','Tip: Dng 89  3♣ 0♦',4,4,4,4,4,20],
  ['3e','3eh','NW','Tip: Dng 77  3♣ 0♦',3,4,4,4,3,19],['1d','1dh','NE','Tip: Dng 77   7♣♦?',4,5,4,4,4,17],
  ['c2','c2h','NE','Tip: Dng 107 3♣ 2♦',3,4,3,3,3,16],['89','89h','NW','Tip: Dng 67  4♣ 1♦',3,4,4,4,3,19],
  ['a6','a6h','NE','Tip: Dng 38  3♣ 1♦',3,3,3,3,3,16],['15','15h','NE','Tip: Dng 38  3♣ 1♦',3,3,3,3,3,17],
  ['ea','eah','NW','Tip: Dng 67  4♣ 1♦',3,3,4,4,3,18],['c1','c1h','SW','Tip: Dng 51  4♣ 1♦',3,3,4,4,3,19],
  ['8e','8eh','SE','Tip: Dng 38  4♣ 0♦',3,3,4,4,3,20],['8d','8dh','NW','Tip: Dng 77  3♣ 0♦',3,2,4,4,3,19],
  ['92','92h','SW','Tip: Dng 89  3♣ 0♦',4,2,4,4,3,19],['79','79h','NE','Tip: Dng 107 3♣ 2♦',2,3,3,3,2,16],
  ['f6','f6h','SW','Tip: Dng 118 4♣ 0♦',4,4,4,3,4,18],['85','85h','SE','Tip: Dng 51  3♣ 2♦',3,3,3,4,3,19],
  ['ba','bah','SE','Tip: Dng 51  4♣ 1♦',3,2,4,4,3,18],['b1','b1h','NW','Tip: Dng 67  4♣ 1♦',3,3,4,4,3,18],
  ['de','deh','SE','Tip: Dng 38  4♣ 0♦',3,3,4,4,3,19],['fd','fdh','SW','Tip: Dng 89  3♣ 0♦',4,3,4,4,3,19],
  ['62','62h','NW','Tip: Dng 67  4♣ 1♦',3,3,4,4,3,18],['69','69h','SW','Tip: Dng 118 3♣ 5♦',3,2,3,3,3,13],
  ['46','46h','SW','Tip: Dng 72  4♣ 2♦',4,3,4,4,3,19],['f5','f5h','NW','Tip: Dng 67   5♣♦?',1,2,3,2,1,13],
  ['8a','8ah','SW','Tip: Dng 51  4♣ 1♦',3,3,4,4,3,19],['a1','a1h','NE','Tip: Dng 38  3♣ 1♦',3,3,3,3,3,15],
  ['2e','2eh','SW','Tip: Dng 118  4♣♦?',4,4,4,4,4,18],['6d','6dh','SW','Tip: Dng 118  4♣♦?',4,4,4,4,4,19],
  ['32','32h','NE','Tip: Dng 107 3♣ 2♦',3,3,3,3,3,15],['59','59h','NE','Tip: Dng 107 3♣ 2♦',3,3,3,3,3,15],
  ['96','96h','SW','Tip: Dng 72  4♣ 2♦',4,3,4,4,3,19],['65','65h','NE','Tip: Dng 107 3♣ 2♦',3,3,3,3,3,15],
  ['5a','5ah','NE','Tip: Dng 128 2♣ 0♦',4,4,4,4,4,22],['91','91h','SE','Tip: Dng 51  4♣ 1♦',3,3,4,4,3,19],
  ['7e','7eh','SW','Tip: Dng 72  4♣ 2♦',4,3,4,4,3,18],['dd','ddh','NW','Tip: Dng 67  3♣ 2♦',1,2,3,3,1,11],
  ['02','02h','SW','Tip: Dng 89  3♣ 0♦',4,2,4,4,3,17],['49','49h','SW','Tip: Dng 128 4♣ 2♦',4,4,4,5,4,22],
  ['e6','e6h','NE','Tip: Dng 107 1♣ 0♦',3,2,3,3,3,13],['d5','d5h','SE','Tip: Dng 51  4♣ 1♦',3,3,4,4,3,17],
  ['2a','2ah','SE','Tip: Dng 51  4♣ 1♦',3,2,4,4,3,17],['81','81h','SW','Tip: Dng 128 4♣ 2♦',4,4,4,5,4,22],
  ['ce','ceh','SW','Tip: Dng 72  4♣ 2♦',4,3,4,4,3,18],['4d','4dh','NE','Tip: Dng 107 3♣ 2♦',3,3,3,3,3,13],
  ['d2','d2h','SW','Tip: Dng 89  3♣ 0♦',4,3,4,4,3,18],['39','39h','SE','Tip: Dng 51  4♣ 1♦',3,3,4,4,3,17],
  ['36','36h','SE','Tip: Dng 38  4♣ 0♦',3,3,4,4,3,18],['45','45h','SW','Tip: Dng 128 4♣ 2♦',4,4,4,5,4,21],
  ['fa','fah','SE','Tip: Dng 51  4♣ 1♦',3,3,4,4,3,18],['71','71h','SW','Tip: Dng 72  3♣ 3♦',2,2,3,3,1,12],
  ['1e','1eh','NE','Tip: Dng 107 1♣ 0♦',3,2,3,3,3,12],['bd','bdh','SE','Tip: Dng 38  4♣ 0♦',3,3,4,4,3,16],
  ['a2','a2h','NE','Tip: Dng 77  5♣ 2♦',5,5,5,5,5,18],['29','29h','SW','Tip: Dng 89  3♣ 0♦',4,2,4,4,3,16],
  ['86','86h','SE','Tip: Dng 38  4♣ 0♦',2,3,4,4,2,17],['b5','b5h','NE','Tip: Dng 107 3♣ 2♦',2,3,3,3,2,13],
  ['ca','cah','NE','Tip: Dng 128 2♣ 0♦',4,4,4,4,4,20],['61','61h','SE','Tip: Dng 38  4♣ 0♦',3,3,4,4,3,17],
  ['6e','6eh','SE','Tip: Dng 38  4♣ 0♦',3,3,4,4,3,17],['2d','2dh','NE','Tip: Dng 77  5♣ 2♦',5,5,5,5,5,19],
  ['72','72h','SW','Tip: Dng 89  3♣ 0♦',4,2,4,4,3,16],['19','19h','SW','Tip: Dng 72  4♣ 2♦',4,3,4,4,3,17],
  ['d6','d6h','SW','Tip: Dng 128 4♣ 2♦',4,3,4,5,4,20],['25','25h','SE','Tip: Dng 38  4♣ 0♦',3,3,4,4,2,17],
  ['9a','9ah','NE','Tip: Dng 107 4♣ 1♦',4,4,4,4,4,16],['51','51h','SW','Tip: Dng 128 3♣ 3♦',4,4,3,5,4,20],
  ['be','beh','SE','Tip: Dng 38  4♣ 0♦',2,3,4,4,2,16],['9d','9dh','SW','Tip: Dng 72  3♣ 3♦',2,2,3,2,1,11],
  ['42','42h','SW','Tip: Dng 89   3♣♦?',4,3,4,3,3,16],['09','09h','NE','Tip: Dng 38  4♣ 0♦',4,4,4,3,4,18],
  ['26','26h','SW','Tip: Dng 72  4♣ 2♦',4,3,4,3,3,16],['95','95h','NE','Tip: Dng 128 2♣ 0♦',4,4,4,3,4,19],
  ['6a','6ah','SE','Tip: Dng 51  4♣ 1♦',3,3,4,3,3,16],['41','41h','SW','Tip: Dng 118 4♣ 4♦',4,3,4,3,4,16],
  ['0e','0eh','SW','Tip: Dng 128 4♣ 2♦',4,3,4,4,4,19],['0d','0dh','NE','Tip: Dng 38  4♣ 0♦',4,4,4,3,4,17],
  ['12','12h','NW','Tip: Dng 67  5♣ 0♦',4,4,5,4,4,20],['f9','f9h','SW','Tip: Dng 128 3♣ 3♦',4,4,3,4,4,20],
  ['76','76h','SW','Tip: Dng 72  3♣ 3♦',4,3,3,3,3,16],['05','05h','SW','Tip: Dng 89   3♣♦?',4,2,3,3,3,16],
  ['3a','3ah','NE','Tip: Dng 128 2♣ 0♦',4,4,3,3,4,19],['31','31h','NE','Tip: Dng 107 3♣ 2♦',4,4,3,3,4,16],
  ['5e','5eh','NW','Tip: Dng 77  3♣ 0♦',4,4,4,4,4,20],['7d','7dh','NE','Tip: Dng 128 2♣ 0♦',4,3,3,3,4,19],
  ['e2','e2h','NE','Tip: Dng 107 2♣ 3♦',2,3,2,2,2,12],['e9','e9h','NE','Tip: Dng 38  3♣ 1♦',4,3,3,3,4,17],
  ['c6','c6h','NE','Tip: Dng 38  3♣ 1♦',4,3,3,3,4,17],['75','75h','SE','Tip: Dng 38  3♣ 1♦',3,2,3,3,3,16],
  ['0a','0ah','NE','Tip: Dng 107 3♣ 2♦',4,4,3,3,4,16],['21','21h','SW','Tip: Dng 128 3♣ 3♦',4,4,3,4,4,19],
  ['ae','aeh','SW','Tip: Dng 128 3♣ 3♦',4,4,3,4,4,20],['ed','edh','NW','Tip: Dng 77  3♣ 0♦',4,4,4,4,4,20],
  ['b2','b2h','NE','Tip: Dng 128 2♣ 0♦',4,4,3,3,3,19],['d9','d9h','SE','Tip: Dng 38  3♣ 1♦',3,3,3,3,3,15],
  ['16','16h','SW','Tip: Dng 118  4♣♦?',5,5,4,4,5,20],['e5','e5h','SW','Tip: Dng 128 3♣ 3♦',4,4,3,4,4,20],
  ['da','dah','NE','Tip: Dng 107 3♣ 2♦',4,4,3,3,4,17],['11','11h','SW','Tip: Dng 128 3♣ 3♦',4,4,3,4,4,20],
  ['fe','feh','NE','Tip: Dng 38  3♣ 1♦',4,3,3,3,4,17],['5d','5dh','NE','Tip: Dng 107 3♣ 2♦',4,4,3,3,4,16],
  ['82','82h','NW','Tip: Dng 67  4♣ 1♦',4,4,4,3,4,20],['c9','c9h','SW','Tip: Dng 128 2♣ 4♦',2,3,2,3,2,13],
  ['66','66h','SE','Tip: Dng 38  3♣ 1♦',2,3,3,3,2,16],['55','55h','SW','Tip: Dng 89   3♣♦?',3,3,2,3,3,14],
  ['aa','aah','NE','Tip: Dng 128 2♣ 0♦',4,4,3,3,4,18]]


#cornerNE = '\u2554\u2550\u2550\u2557\n\
#\u2551.\u2261\u2551\n\
#\u2551..\u2551\n\
#\u255a\u2550\u2550\u255d'
#cornerNE = '╔══╗\n║.≡║\n║..║\n╚══╝'
#upright = 2557
#bottomright = 255d
#bottomeleft = 255a
#upleft = 2554
#floor = '.'
#vert = 2551
#horz = 2550

pex("target remote | qemu-system-i386 -S -gdb stdio -m 16 -boot c -hda rogue")
pex("set pagination off")
pex("set architecture i8086")
pex("display /i ($cs*16)+$pc")
pex("stepi 11")
pex("br *0x7c1b")   # generate_dungeon:
pex("br *0x7cac")   # User finished a directional move
pex("br *0x7cda")   # Where GOLD is checked
pex("br *0x7ce5")   # Where armor is found
pex("br *0x7ce9")   # Where sword is found
pex("br *0x7cf2")   # Where food is found
pex("br *0x7d1c")   # Where battle has initiated
pex("br *0x7d1e")   # Enemy is identified
pex("br *0x7d28")   # Enemy is attacked
pex("br *0x7d30")   # Enemy attacks
pex("br *0x7d3c")   # Enemy Dead
pex("br *0x7cf7")   # Death Check
pex("br *0x7ced")   # Where trap is found
pex("br *0x7c21")   # You won

def game_done():
  print("\nGamePlay Statistics\n--------------------")
  print("Steps: {}".format(total_steps))
  print("HP: {}".format(hp))
  print("ATT: {}".format(attack))
  print("DEF: {}".format(armor))
  print("Wealth: {}".format(grand_total_gold))
  print("Obesity: {} food eaten".format(grand_total_food))
  print("Foot Shred: {} traps stepped on".format(grand_total_traps))
  print("Fights: {}\n".format(grand_total_enemies))

  # Determine Dungeons crawled through / cleared
  level = pex("x/bx 0x6f25")
  matches = re.match(r'.*0x6f25:\s+0x(.+)', level)
  level = matches.group(1)
  level = int(level, 16) - 1
  #level -= 1
  yendor = pex("x/bx 0x6f24")
  matches = re.match(r'.*0x6f24:\s+0x(.+)', yendor)
  yendor = matches.group(1)
  yendor = int(yendor, 16)
  if yendor != 1 and level != 25:
    level = 50-level
  print("You have cleared {} dungeon(s)".format(level))
  pex("quit")
  quit()

while i < 1000000:
  pex("cont")
  ip = pex("info register eip")

  # Win Check
  if re.match(r'.+0x7c21.+', ip):
    win = pex("x/bx 0x6f25")
    matches = re.match(r'.*0x6f25:\s+0x(.+)', win)
    win = matches.group(1)
    win = int(win, 16)
    if win == 0:
      clear()
      print("You Win!")
      game_done()

  # Death Check
  if re.match(r'.+0x7cf7.+', ip):
    # Get Starvation
    starve = pex("x/hx 0x6f28")      # memory location of starve count
    matches = re.match(r'.*0x6f28:\s+0x(.+)', starve)
    starvation = matches.group(1)
    starvation = int(starvation, 16)  # 254 is max

    # Get HP
    hp = pex("info register ax")
    matches = re.match(r'.*ax\s+\S+\s+(.+)',hp)
    hp = int(matches.group(1))

    if hp < 0:
      if starvation < 0:
        clear()
        print("You Died of starvation!")
        game_done()
      if hp < 0 and damaged_by == 'battle':
        clear()
        print("You Died in battle!")
        game_done()
      if hp < 0 and damaged_by == 'trap':
        clear()
        print("You Died of clumsiness!")
        game_done()

  #Check if new dungeon
  if re.match(r'.+0x7c1b.+', ip):
    # New Dungeon, init item total

    dungeonseed = "Mystery Dungeon"
    dungeon_corner = "NW"
    amulet_corner = "SW"
    dungeon_tip = "Tip: None"
    dungeon = pex("x/hx 0x6f2a")      # memory location of seed
    matches = re.match(r'.*0x6f2a:\s+0x[0-9a-f]{2}(.+)', dungeon)
    dungeonseed = matches.group(1)
    #print(dungeonseed)
    for dungeon in dungeons:
      #print(dungeon[0])
      if dungeon[0] == dungeonseed:
        dungeon_number = str(dungeon[1])
        dungeon_corner = dungeon[2]
        try:
          amulet_corner = dungeon[10]
        except:
          pass
        dungeon_tip = dungeon[3]
        total_gold = dungeon[4]
        total_traps = dungeon[5]
        total_food = dungeon[6]
        total_armor = dungeon[7]
        total_swords = dungeon[8]
        total_enemies = dungeon[9]
        break
      else:
        dungeon_number = '?'
    #print("Dungeon: {}\n".format(dungeonseed))

  #Gold?
  if re.match(r'.+0x7cda.+', ip):
    goldcheck = pex("info register al")
    matches = re.match(r'.+0x(\S+).+', goldcheck)
    goldcheck = matches.group(1)
    if goldcheck == 'f':
      gold += 1
      grand_total_gold += 1
      total_gold -= 1

  #Armor
  if re.match(r'.+0x7ce5.+', ip):
    total_armor -= 1
    grand_total_armor += 1

  #Sword
  if re.match(r'.+0x7ce9.+', ip):
    total_swords -= 1
    grand_total_swords += 1

  #Food
  if re.match(r'.+0x7cf2.+', ip):
    total_food -= 1
    grand_total_food += 1

  #Trap
  if re.match(r'.+0x7ced.+', ip):
    damaged_by = 'trap'
    grand_total_traps += 1

  #Battle
  if re.match(r'.+0x7d1c.+', ip):
    total_enemies -= 1
    grand_total_enemies += 1
    print("Entering Battle with: ",end='')
    damaged_by = 'battle'

  #Enemy Identified
  if re.match(r'.+0x7d1e.+', ip):
    clear()
    enemy = pex("info register al")
    matches = re.match(r'.+\s+(\d+)$', enemy)
    enemy = int(matches.group(1))
    enemyHP = (enemy * 2) + 1
    enemyName = chr(enemy + 64)
    enemyName = enemynames[enemyName]
    print("{} ({} HP)".format(enemyName,enemyHP))

  #You Attack
  if re.match(r'.+0x7d28.+', ip):
    swing = pex("info register al")
    matches = re.match(r'.+\s+(\d+)$', swing)
    swing = int(matches.group(1))
    print("\nYou attack {}, giving {} damage".format(enemyName,swing))
    enemyHP -= swing
    print("{} now has {} HP".format(enemyName,enemyHP))

  #Enemy Attacks
  if re.match(r'.+0x7d30.+', ip):
    bites = pex("info register al")
    matches = re.match(r'.+\s+(\d+)$', bites)
    bites = int(matches.group(1))
    if (bites-armor > 0):
      print("{} attacks with strength of {}. Factoring you armor, you take {} damage".format(enemyName,bites,bites-armor))
    else:
      print("{} attacks with strength of {}, but your armor is stronger, no damage!".format(enemyName,bites))

  #Enemy Dead
  if re.match(r'.+0x7d3c.+', ip):
    print("You killed the enemy!")

# Reference output
#╔══╦══════════════════╗
#║.≡║ Dungeon xxx  nnn♥║
#║..║ 0* 0♦ 0♣ 0◘ 0↑ 0☻║
#╠══╩══════════════════╣
#║Att:nnn Def:nnn $:nnn║
#╠═════════════════════╣
#║  Next Dungeon xxx   ║
#║  Tip: Dng nnn 2♣ 1♦ ║
#╚═════════════════════╝
  #User Moved
  if re.match(r'.+0x7cac.+', ip):

    # Get level
    level = pex("x/bx 0x6f25")
    matches = re.match(r'.*0x6f25:\s+0x(.+)', level)
    level = matches.group(1)
    level = int(level, 16)

    total_steps += 1
    clear()
    print('╔══╦══════════════════╗')  # Top Border
    # First row of corner piece
    print("║", end='')
    if dungeon_corner == 'NW': print("≡", end='')
    elif amulet_corner == 'NW' and level == 26: print("♀",end='')
    else: print(".",end='')
    if dungeon_corner == 'NE': print("≡", end='')
    else: print(".",end='')
    print("║", end='')

    # Get Starvation and print dungeon number
    starve = pex("x/hx 0x6f28")      # memory location of starve count
    matches = re.match(r'.*0x6f28:\s+0x(.+)', starve)
    starvation = matches.group(1)
    starvation = int(starvation, 16)
    print(' Dungeon {:3} {:3}♥ ║'.format(dungeon_number,int((254-starvation)/2)))

    # Second row of corner piece
    print("║", end='')
    if dungeon_corner == 'SW': print("≡", end='')
    elif amulet_corner == 'SW' and level == 26: print("♀",end='')
    else: print(".",end='')
    if dungeon_corner == 'SE': print("≡", end='')
    else: print(".",end='')
    print("║", end='')

    # Print current items
    print("{}* {}\u2666 {}\u2663 {}\u25D8 {}\u2191 {:2}\u263B║".format(total_gold,total_traps,total_food,total_armor,total_swords,total_enemies))

    # Print Spacer
    print('╠══╩══════════════════╣')

    # Get Attack
    sword = pex("x/bx 0x6f22")      # Memory location of attackttack
    matches = re.match(r'.*0x6f22:\s+0x(.+)', sword)
    attack = matches.group(1)
    attack = int(attack, 16) 
    # Get Armor
    shield = pex("x/bx 0x6f23")      # Memory location of defense
    matches = re.match(r'.*0x6f23:\s+0x(.+)', shield)
    armor = matches.group(1)
    armor = int(armor, 16)  
    # Print attack, defense, and gold
    print('║Att:{:3} Def:{:3} $:{:3}║'.format(attack,armor,gold))

    # Next Dungeon
    next_dungeon = pex("x/hx 0x6f2a")
    matches = re.match(r'.*0x6f2a:\s+0x[0-9a-f]{2}(.+)', next_dungeon)
    next_dungeonseed = matches.group(1)
    for next_dungeon in dungeons:
      if next_dungeon[0] == next_dungeonseed:
        next_dungeon_number = str(next_dungeon[1])
        break
      else:
        next_dungeon_number = '?'
    print("╠═════════════════════╣\n║  Next Dungeon: {:3}  ║".format(next_dungeon_number))

    # Print the tip
    print('║  {} ║\n╚═════════════════════╝'.format(dungeon_tip))

pex("quit")
