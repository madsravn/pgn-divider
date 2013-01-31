#!/bin/bash
N=0
COLOR="white"

cat $1 | while read LINE ; do
    if [[ "$LINE" == *"Event"* ]]
    then
        N=$((N+1));
        ENTERLAST="no"
        ELO=""
    fi
    echo $LINE >> "game$N.pgn"
    
    if [[ "$LINE" == *"White"*"madsravn"* ]]
    then
        OUTPUT="In game$N.pgn mads is white"
        COLOR="white"
    fi
    if [[ "$LINE" == *"Black"*"madsravn"* ]]
    then
        OUTPUT="In game$N.pgn mads is black"
        COLOR="black"
    fi
    if [[ "$LINE" == *"Result"* ]]
    then
        LOST=" mads lost"
        if [[ "$COLOR" == "white" && "$LINE" == *"1-0"* ]]
        then
            LOST=" mads won"
        fi
        if [[ "$COLOR" == "black" && "$LINE" == *"0-1"* ]]
        then
            LOST=" mads won"
        fi
        if [[ "$LINE" == *"1/2-1/2"* ]]
        then
            LOST=" game tied"
        fi
        OUTPUT=$OUTPUT$LOST
    fi
    if [[ "$LINE" == *"WhiteElo"* ]]
    then
        WELO="${LINE//[!0-9]}"
    fi
    if [[ "$LINE" == *"BlackElo"* ]]
    then
        BELO="${LINE//[!0-9]}"
        ENTERLAST="yes"
    fi
    

    if [[ "$ENTERLAST" == "yes" && "$OUTPUT" != "" ]]
    then
        if [[ "$COLOR" == "white" ]]
        then
            ELO=$((WELO-BELO))
        else
            ELO=$((BELO-WELO))
        fi

        echo "$OUTPUT $ELO"
        OUTPUT=""
        ENTERLAST="no"
        ELO=""
    fi
done
