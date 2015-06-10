#!/usr/bin/env bash
LISTE_SERVEURS='pnexpl01 pnexpl02 qar201 Stephane Edgar David Jerome Tien Thierry '
SPOOLSIZE=$1
REAPDIR=reap
EXECDIR=encours
SIG_FIN=SIG_FIN

function getSpoolList {
: << =cut
=head2 getSpoolList

renvoie une liste de $SPOOLSIZE elements $SPOOLSIZE est le premier arg en int

=cut

SPOOLSIZE=$1
x=0;
liste=''
while [ "$x" -lt "$SPOOLSIZE" ]
do
  liste="$liste $x"
  x=$((x+1))
done
echo $liste

}

spool="$(getSpoolList $SPOOLSIZE)"
timeout=10

function nextServer {
echo $LISTE_SERVEURS | awk '{print $1}'

}

function majListeServeur {

echo $LISTE_SERVEURS | sed "s/$serveur//g"

}

function Ordonnanceur {
: << =cut
=head2 Ordonnanceur

dirige les executions

=cut

#preparation



Surveillant prepare 
Surveillant surveille &
echelle=30
while [ ! -z "$LISTE_SERVEURS" ]
do 
  spool=$(Surveillant reap)
  for element in $spool
  do
    serveur=$(nextServer)
    LISTE_SERVEURS=$(majListeServeur)
    echo papa $$
    if [ "$echelle" -eq 5 ];then 
      echelle=30
    else 
      echelle=5
    fi
    Executant prepare Test $element $serveur
    Executant reserve
    Executant go &
    echo $!>$EXECDIR/$element/PID

  done

done

while [ $(ls $EXECDIR | wc -w) -ne 0 ]
do
  sleep 1
done
mkdir $SIG_FIN

}


function Surveillant {

: <<=cut

=head2 Surveillant

=over

=item * 

verif temps exec

=item * 

kill si temps depassé

=item * 

se termine si sig_fin

=back

=cut

REAP=''
SPOOLER_CMD=$1
case $SPOOLER_CMD in
  reap) 

    liste=" "
    while [ $(echo $liste | wc -w) -eq 0 ]
    do
      liste=$(for i in $(ls -l $REAPDIR | awk '/^d/ {print $NF}');do echo $i;done)
      sleep 1 
    done
    echo $liste
    ;;
  prepare)
    for position in $spool
    do
      mkdir -p $REAPDIR/$position
    done
    mkdir $EXECDIR
    ;;
  surveille)
    while [ ! -d "$SIG_FIN" ]
    do
      encours=$(for i in $(ls -l $EXECDIR | awk '/^d/ {print $NF}');do echo $i;done)
      for i in $encours
      do
	date_actuelle=$(date +%s)
	date_debut=$(cat $EXECDIR/$i/DATE 2>/dev/null)
	if [ $? -ne 0 ];then continue;fi
	date_diff=$((date_actuelle - date_debut))
	if [ $date_diff -gt $timeout ]
	then
	  PID=$(cat $EXECDIR/$i/PID)
	  kill $PID
	  if [ $? -eq 0 ];then
	    echo $PID killed
	    Executant prepare fake $i fake
	    postExec
	  fi
	fi




      done

    done
    fin
    exit
    ;;



esac

}

function Executant {

: <<=cut

=head2 Executant

=over

=item *

d'informer le Surveillant du PID

=item *

d'executer

=item *

de supprimer l'info apres exec

=item *

de liberer la file

=back

=cut
case $1 in 

  prepare)
    shift
Executant_CMD="$1"
Executant_ID="$2"
Executant_SRV="$3"
Executant_DIR="$EXECDIR/$Executant_ID"
Executant_REAP="$REAPDIR/$Executant_ID"
;;
reserve)
mv $Executant_REAP $Executant_DIR
;;

go)
  shift
while [ ! $Executant_DIR/PID ]
do
  sleep 0.1

done
Executant_PID=$(cat $Executant_DIR/PID)

echo $(date +%s)>$Executant_DIR/DATE
echo $Executant_SRV>$Executant_DIR/SRV
$Executant_CMD 
postExec
exit
;;

esac



}

function postExec {
echo "Je nettoie... $Executant_DIR"
rm $Executant_DIR/PID $Executant_DIR/DATE $Executant_DIR/SRV
rmdir $Executant_DIR
echo "et je reapro... $Executant_REAP"
mkdir $Executant_REAP

}

function Test {
    echo action a faire $Executant_ID $Executant_SRV $Executant_PID
    #while :;do sleep 1;done
    sleep $echelle
}

function fin {
rm -Rf $REAPDIR
rm -Rf $EXECDIR
rmdir $SIG_FIN
echo "that's all folks!"

}
Ordonnanceur

