@CLASS
scroller



@create[h]
$hConf[^hash::create[$h]]

$hConf.sKeyName[^if(def $hConf.sKeyName){$hConf.sKeyName}{page}]


$hConf.sSeparator[^if(def $hConf.sSeparator){$hConf.sSeparator}{<span class="separator">&middot^;</span>}]
$hConf.sClass[^if(def $hConf.sClass){$hConf.sClass}{&middot^;}]
$hConf.iRowsAll[^hConf.iRowsAll.int(0)]
#$hConf.iRowsAll(100) Это если надо потестировать
$hConf.iRowsPerPage[^hConf.iRowsPerPage.int(25)]

^if($form:[$hConf.sKeyName]){
	$hConf.iRowCurrent($form:[$hConf.sKeyName])
}{
	$hConf.iRowCurrent(1)
}



^if($hConf.iRowsAll>0 && $hConf.iRowsAll/$hConf.iRowsPerPage >1){
	$hConf.iRowLast(^math:ceiling($hConf.iRowsAll/$hConf.iRowsPerPage))
}{
	$hConf.iRowLast(1)
}


^if(!def $hConf.sGroupsType){$hConf.sGroupsType[separate]} ^rem{separate | both | left}

# если нам передали хэш для формирования пути - берем его, иначе $form:fields, причем
^if(!$hConf.hQuery){
	$hConf.hQuery[^hash::create[$form:fields]]
}
^hConf.hQuery.delete[$hConf.sKeyName]

^hConf.hQuery.delete[qtail]
^hConf.hQuery.delete[nameless]

^if(!def $hConf.sPath){
	$hConf.sPath[./]
}


#$hConf.sCurrQuery[${hConf.sPath}?^hConf.hQuery.foreach[k;v]{^if(def $v){$k=^taint[uri][$v]&amp^;}}[&amp^;]page=]

# тут "собираем" строку запроса, т.к. она одинаковая для всех ссылок  на страницы

$hConf.sCurrQuery[^hConf.hQuery.foreach[k;v]{^if(^k.mid(0;7) ne 'xcvar__' && ^v.trim[] ne ''){&${k}=^taint[uri][^v.trim[]]}}]





@test[]

$self.hConf.sLink

#-- ^print:url[$form:fields] --
#^print:o[$self.hConf]

#$iItems($hConf.iRowsAll/$hConf.iRowsPerPage)


#$iItems

#$hConf.iRowLast


#$iOrder
#$iOrder($hConf.iRowLast)





@getRanges[iStart;iStop;iOrder][i;iLeft;iRight]
$iPrev($hConf.iRowCurrent-1)
$iNext($hConf.iRowCurrent+1)
<span class='level${iOrder}'>
$i($iStart)
^while($i <= $iStop){
	$iLeft($i)
	$iRight(
		^if(^eval($i+^math:pow(10;$iOrder-1)-1)<=$iStop){^eval($i+^math:pow(10;$iOrder-1)-1)}{$iStop}

	)

	^if($hConf.iRowCurrent >=$iLeft && $hConf.iRowCurrent <= $iRight){
		^if($iLeft != $iRight){
			^self.getRanges($iLeft;$iRight;^eval($iOrder-1))
		}{
			$iCurrent($i)
#			^switch($i){
#				^case[1]{<b>$i&rarr^;</b>}
#				^case[$hConf.iRowLast]{<b>&larr^;$i</b>}
#				^case[DEFAULT]{<b>&larr^;$i&rarr^;</b>}
#			}
			<b class='fake_a'>$i</b>
			$iNext($i+1)
		}

	}{
		^if($iLeft != $iRight){
			^self.printGroup[$iLeft;$iRight]
		}{
			^self.printItem[$iLeft]
		}
	}
	$i($i+^math:pow(10;$iOrder-1))
}[$hConf.sSeparator]
</span>

@printItem[i]
<span class='item'>^self.link[$i]</span>


@printGroup[iLeft;iRight]
^switch[$hConf.sGroupsType]{
	^case[left]{
		<span class='group'>^self.link[$iLeft]<span style='display:none'>–^self.link[$iRight]</span></span>
		^if($iRight == $hConf.iRowLast){$self.hConf.sSeparator<span class='group'>^self.link[$iRight]</span>}
	}
#	^case[both]{<span class='group'>^self.link[$iLeft]</span>}
	^case[separate;DEFAULT]{<span class='group'>^self.link[$iLeft]–^link[$iRight]</span>}
}



@link[i]
$result[<a
	^if($i==$hConf.iRowCurrent+1){id='next_link'}
	^if($i==$hConf.iRowCurrent-1){id='prev_link'}
	href='^printHref[$i]'>$i</a>]


@getOrder[i][iOrder]
$result(1)
^while($i/^math:pow(10;$result)>1){
	$result($result+1)
}



@print[][buff]
#	-- $hConf.sGroupsType --
#^print:o[$hConf]
	^if($self.hConf.iRowLast>1){
		<div class='$self.hConf.sClass'>
			$buff[
				^self.printFirst[]
				^self.printScroll[]
				^self.printLast[]
			]
			$buff[^buff.match[\n][g]{ }]
			$buff[^buff.match[\s+^taint[regex][$hConf.sSeparator]\s+][g]{${hConf.sSeparator}}]
			$buff[^buff.match[>\s+<][g]{><}]

			$buff[^buff.match[><][g]{><wbr><}]

			$buff

			<div class='comment' style='font-size:12px^;color:#ccc^;text-align:center'> предыдущая &larr^; Ctrl &rarr^; следующая</div>
		</div>
	}{
		<div class='$self.hConf.sClass'>
		</div>
	}


@printFirst[]
^if($self.hConf.iRowCurrent != 1){
	$result[&larr^;<a href='^printHref[1]'>первая</a>]
}{
	$result[&larr^;<span class='fake_a first_last'>первая</span>]
}


@printLast[]
^if($self.hConf.iRowCurrent != $self.hConf.iRowLast){
	$result[<a href='^printHref[$self.hConf.iRowLast]'>последняя</a>&rarr^;]
}{
	$result[<span class='fake_a first_last'>последняя</span>&rarr^;]
}


@printScroll[]
$iOrder(^self.getOrder[$hConf.iRowLast])
$self.hConf.sSeparator^self.getRanges[1;$hConf.iRowLast;$iOrder]$self.hConf.sSeparator

#$result[$self.hConf.sSeparator^for[i](1;$self.hConf.iRowLast){^if($i==$self.hConf.iRowCurrent){<b>$i</b>}{<a href='^print:url[$.page[$i]]'>$i</a>}}[$self.hConf.sSeparator]$self.hConf.sSeparator]


@printHref____OLD[i][query]
$query[^request:uri.match[^^[^^?]*\?(.*)][]{$match.1}]
^if(^query.match[${hConf.sKeyName}=]){
	$result[${hConf.sPath}?^taint[as-is][^query.match[${hConf.sKeyName}=\d*][]{${hConf.sKeyName}=$i}]]
}{
	$result[${hConf.sPath}?${hConf.sKeyName}=${i}]
}
#$i
#$result[~~$query]


@printHref[i][query]

$result[${hConf.sPath}?${hConf.sKeyName}=${i}$hConf.sCurrQuery]












