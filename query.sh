#!/bin/bash

sql="$2"
case "$2" in
"deployed")
    sql="SELECT tl.time,COUNT(a.agentid) FROM timelist as tl
         LEFT JOIN agents as a on a.entertime <= tl.time and (a.exittime >= tl.time or a.exittime isnull) and a.simid=tl.simid
         WHERE a.prototype='$3'
         GROUP BY tl.time;"
;;
"unfueled")
    sql="SELECT tl.time,ifnull(u.num, 0) from timelist as tl
    left join (SELECT simid,time,COUNT(value) as num FROM timeseriespower where value = 0 group by time) as u ON tl.time=u.time and tl.simid=u.simid"
;;
"unfueled-proto")
    sql="SELECT p.time,COUNT(a.prototype) FROM timeseriespower as p
         JOIN agents AS a ON a.agentid = p.agentid
         WHERE value = 0 AND a.prototype = '$3'
         GROUP BY p.time;
         "
;;
"protos")
    sql="SELECT Prototype FROM Prototypes;"
;;
"power-proto")
    sql="SELECT time,total(Value) from timeseriespower as p
           LEFT JOIN agents as a on a.agentid=p.agentid AND a.simid=p.simid
           WHERE a.Prototype='$3'
           GROUP BY Time
           "
;;
"power")
    sql="SELECT Time,total(Value) from TimeSeriesPower as p
           LEFT JOIN agents as a on a.agentid=p.agentid AND a.simid=p.simid
           GROUP BY Time
           "
;;
"trans-commods")
    sql="SELECT commodity,count(*) FROM transactions group by commodity;"
;;
"flow-proto")
    sql="SELECT tl.Time,IFNULL(sub.qty,0) FROM timelist as tl
         LEFT JOIN (
            SELECT t.time as time,SUM(r.quantity) as qty FROM transactions as t
            JOIN resources as r ON t.resourceid=r.resourceid AND r.simid=t.simid
            JOIN agents as send ON t.senderid=send.agentid AND send.simid=t.simid
            JOIN agents as recv ON t.receiverid=recv.agentid AND recv.simid=t.simid
            WHERE send.prototype='$3' AND recv.prototype='$4'
            GROUP BY t.time
         ) AS sub ON tl.time=sub.time;
        "
;;
"flow-proto-nuc")
    sql="SELECT tl.Time,IFNULL(sub.qty,0) FROM timelist as tl
         LEFT JOIN (
            SELECT t.time as time,SUM(r.quantity) as qty FROM transactions as t
            JOIN resources as r ON t.resourceid=r.resourceid AND r.simid=t.simid
            JOIN agents as send ON t.senderid=send.agentid AND send.simid=t.simid
            JOIN agents as recv ON t.receiverid=recv.agentid AND recv.simid=t.simid
            JOIN compositions as c ON c.qualid=r.qualid AND c.simid=r.simid
            WHERE send.prototype='$3' AND recv.prototype='$4' AND c.nucid=$5
            GROUP BY t.time
         ) AS sub ON tl.time=sub.time;
        "
;;
"inv-proto")
    sql="SELECT tl.Time,IFNULL(sub.qty,0) FROM timelist as tl
         LEFT JOIN (SELECT tl.Time as time,TOTAL(inv.Quantity) AS qty FROM timelist as tl
            JOIN inventories as inv on inv.starttime <= tl.time and inv.endtime > tl.time AND tl.simid=inv.simid
            JOIN agents as a on a.agentid=inv.agentid AND a.simid=inv.simid
            WHERE a.prototype='$3'
            GROUP BY tl.Time
         ) AS sub ON sub.time=tl.time;
         "
;;
"inv-proto-nuc")
    sql="SELECT tl.Time,IFNULL(sub.qty,0) FROM timelist as tl
         LEFT JOIN (SELECT tl.Time as time,TOTAL(inv.Quantity) AS qty FROM timelist as tl
            JOIN inventories as inv on inv.starttime <= tl.time and inv.endtime > tl.time AND tl.simid=inv.simid
            JOIN compositions as c on c.qualid=inv.qualid AND c.simid=inv.simid
            JOIN agents as a on a.agentid=inv.agentid AND a.simid=inv.simid
            WHERE a.prototype='$3' AND c.NucId IN ($4)
            GROUP BY tl.Time
         ) AS sub ON sub.time=tl.time;
         "
;;
esac

postpath=$(which cycpost)
if [[ -n $postpath ]]; then
    cycpost $1 > /dev/null
fi

if [[ $sql == "" ]]; then
    return 0;
fi

sqlite3 "$1" "CREATE INDEX IF NOT EXISTS ts_power_simid_time_agentid_value ON TimeSeriesPower (simid,time,agentid,value);"

sqlite3 -separator '    ' "$1" "$sql"
#fname=.$(uuidgen).dat
#sqlite3 -column "$1" "$sql" > $fname
#gnuplot -p -e "plot "\""$fname"\"" using 1:2 with linespoints;"
#rm $fname

