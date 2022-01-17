(sleep 1; echo $USER; sleep 1; echo $PASSWORD; sleep 1; echo dev; sleep 1;) | telnet $1 2>/dev/null  | grep 'Fault\|None' | awk '{print $3, $4,"|", $10}' | grep -c М
