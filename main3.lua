--$Name:Один день лета$
--$Author:Пётр Косых$
--$Info:Игра для Инстедоз-6$

require "fmt"
fmt.dash = true
fmt.quotes = true

loadmod 'mp-ru'

pl.description = [[Тебя зовут Серёжа и тебе 8 лет.]];

Verb {
	"просыпаться,просыпайся";
	"Wake";
}

Path = Class {
	['before_Walk,Enter'] = function(s) walk (s.walk_to) end;
	before_Default = function(s)
		if s.desc then
			p(s.desc)
			return
		end
		p ([[Ты можешь пойти в ]], std.ref(s.walk_to):noun('вн'), '.');
	end;
	default_Event = 'Walk';
}:attr'scenery';

Prop = Class {
	before_Default = function(s, ev)
		p ("Тебе нет дела до ", s:noun 'рд', ".")
	end;
}:attr 'scenery'

Careful = Class {
	before_Default = function(s, ev)
		p ("Лучше оставить ", s:it 'вн', " в покое.")
	end;
}:attr 'scenery'

Furniture = Class {
	['before_Push,Pull,Transfer'] = "Пусть лучше стоит там, где стоит.";
}:attr 'static'

room {
	-"сон";
	nam = 'main';
	title = false;
	dsc = false;
	before_Look = [[Во сне ты снова летал.
Раскинув руки, ты парил у самого потолка гостиной комнаты разглядывая
верхушки книжных шкафов и ковёр на полу. Ты был счастлив. Счастлив настолько,
что понял... Это всего лишь сон.^^Тебе пора просыпаться!]];
	before_Default = "Тебе пора просыпаться.";
	before_Wake = function() move(pl,  'bed') end;
}

obj {
	-"кровать";
	nam = 'bed';
	found_in = 'bedroom';
	description = [[Кровать кажется тебе огромной.]];
}:attr 'scenery,supporter,enterable'

obj {
	-"одежда|шорты|майка";
	nam = 'clothes';
	init_dsc = [[На полу валяется твоя одежда.]];
	before_Disrobe = function(s)
		if s:hasnt 'worn' then
			return false
		end;
		p [[Зачем раздеваться? Ещё не время спать.]];
	end;
	found_in = 'bedroom';
}:attr 'clothing'

room {
	-"спальня,спальная комната,комната";
	nam = 'bedroom';
	title = 'спальня';
	out_to = 'livingroom';
	Smell = [[Ты чувствуешь запах свежей сдобы.]];
	Listen = [[Ты слышишь чириканье воробьёв за окном.]];
	onexit = function(s)
		if _'clothes':hasnt 'worn' then
			p [[Тебе стоит надеть свою одежду.]]
			return false
		end
	end;
	before_Any = function(s, ev)
		if not pl:inside'bed' then
			return false
		end
		if ev == 'Exam' or ev == 'Exit' or ev == 'Walk' or ev == 'GetOff' then
			return false
		end
		p [[Сначала надо слезть с кровати.]]
	end;
	dsc = function(s)
		if s:once() then
			pn [[Ты открываешь глаза и видишь белые клубы облаков.
А под облаками -- ствол высокой сосны, уходящий прямиком в небо. Некоторое время ты смотришь на
неровную кору, длинные иголки, большие шишки и вспоминаешь...^^
Лето. Ты живёшь у бабушки и дедушки в одноэтажном доме. Прямо напротив окна спальни
растёт сосна, которую ты видишь каждое утро, когда просыпаешься в своей кровати.^]]
		end
		p [[В спальне светло. Белые гардины колышутся от легкого ветерка. Отсюда ты можешь пройти в гостиную.]];
	end;
}: with {
	Careful {
		-"окно|гардины";
		before_Open = "Здесь и так светло и свежо.";
		before_Close = "Лучше пусть будет так, как есть.";
		before_Exam = [[Ты можешь долго наблюдать, как колышутся гардины на сквозняке.]];
	}:attr 'scenery';
	obj {
		-"сосна|шишки|иголки|кора";
		before_Exam = [[Интересно, сколько лет этой сосне?]];
		before_Default = [[Сосна находится за окном.]]
	}:attr 'scenery';
	Path {
		-"гостиная";
		walk_to = 'livingroom';
		desc = [[Ты можешь пойти в гостиную.]];
	};
}

obj {
	-"телевизор";
	['before_Push,Pull,Take,Transfer'] = 'Телевизор слишком тяжёлый.';
	description = function(s)
		if s:has'on' then
			p [[По телевизору идут новости. Скучно.]]
		else
			p [[Черно-белый телевизор с красивым названием "Берёзка".]];
			return false
		end
	end;
	found_in = 'livingroom';
}:attr 'static,switchable'

obj {
	-"зеркало";
	description = [[Зеркало стоит в углу комнаты. Оно очень большое и старинное. Ты любишь разглядывать в нём своё отражение и отражение гостиной.
Просто удивительно, что там всё наоборот. Почему лево и право меняется местами, а верх и низ -- нет?]];
	found_in = 'livingroom';
}:attr 'static';

obj {
	-"диван";
	description = [[Повидавший многое на своём веку диван стоит у стены напротив телевизора. Его пружины совсем ослабли, но он стал от этого ещё мягче.]];
	found_in = 'livingroom';
}:attr 'static,supporter,enterable'

obj {
	nam = 'clock';
	-"часы|маятник";
	num = 1;
	description = [[Старинные часы висят рядом с входом в коридор. Ты любишь смотреть, как равномерно качается маятник и слушать
гулкий бой, который разносится по дому каждый час.]];
	found_in = 'livingroom';
	before_Exam = function(s)
		if s:once() then
			DaemonStart 'clock'
		end
		return false
	end;
	daemon = function(s)
		s.num = s.num + 1
		if s.num > 3 then
			if not here() ^ 'livingroom' then
				p [[Ты слышишь, как из гостиной доносится бой часов.]]
			else
				p [[Ты слышишь, как часы начинают бить.]]
			end
			p (fmt.em([[^Бам! Бам! Бам! Бам! Бам! Бам! Бам! Бам! Бам! ...]]))
			s:daemonStop()
		end
	end;
	before_Default = function(s, ev)
		p ("Лучше оставить ", s:it 'вн', " в покое.")
	end;
}:attr 'static';

obj {
	-"окно|окна|свет";
	nam = 'window';
	description = [[Сквозь окно льётся свет летнего утра.]];
	before_Open = [[Всё и так хорошо. Может быть просто выйти погулять?]];
}:attr 'scenery,openable';

room {
	-"гостиная";
	title = 'гостиная';
	nam = 'livingroom';
	Smell = [[Ты чувствуешь запах пирожков.]];
	Listen = [[Ты слышишь ход часов.]];
	dsc = [[Гостиная кажется тебе огромной. Ты можешь пройти в спальню или коридор.]];
}: with {
	Path {
		-"спальня,спальная";
		walk_to = 'bedroom';
	};
	Path {
		-"коридор";
		walk_to = 'corridor';
	};
	'window';
}

room {
	-"коридор";
	title = 'коридор';
	nam = 'corridor';
	Smell = [[Ты чувствуешь запах пирожков из кухни.]];
	dsc = [[Из узкого коридора можно попасть в гостиную, кухню и комнату дедушки.]];
}: with {
	Path {
		-"гостиная";
		walk_to = 'livingroom'
	};
	Path {
		-"комната дедушки,комната";
		walk_to = 'grandroom';
	};
	Path {
		-"кухня";
		walk_to = 'kitchenroom';
		desc = [[Ты можешь пойти на кухню.]];
	};
}

Furniture {
	nam = 'ironbed';
	-"железная кровать,кровать";
	found_in = 'grandroom';
	description = [[Железная кровать дедушки хорошо пружинит. На ней очень здорово прыгать.]];
}:attr 'supporter,enterable';

obj {
	nam = 'news';
	-"газета|Правда";
	found_in = 'table';
	description = [[Газета "Правда" за 15 мая 1986 года.
Ты заметил, что название одной из статей выделено красной ручкой.
^^Выступление М. С. Горбачева по советскому телевидению.^^
"Добрый вечер, товарищи! Все вы знаете, недавно нас постигла беда - авария на Чернобыльской атомной электростанции... Она больно затронула советских людей, взволновала международную общественность. Мы впервые реально столкнулись с такой грозной силой, какой является ядерная энергия, вышедшая из-под контроля."^^Что это значит?]];
}

Furniture {
	nam = 'table';
	-"стол";
	found_in = 'grandroom';
	description = [[Дедушкин стол занимает правую половину комнаты. Он очень старый. В столе есть выдвижной ящик.]];
	['before_Enter,Climb'] = [[Не стоит испытывать стол на прочность.]];
}:attr 'supporter';

Verb {
	"[вы|за]двин/уть",
	"{noun}/вн,openable : Pull"
}

Verb {
	"задви/нуть",
	"{noun}/вн,openable : Push"
}
Verb {
	"выдви/нуть",
	"{noun}/вн,openable : Pull"
}

obj {
	nam = 'key';
	-"ключ";
	found_in = 'tablebox';
	description = "Это небольшой ключик, который уже начал ржаветь.";
}

obj {
	nam = 'wire';
	-"скрепка,проволока";
	found_in = 'tablebox';
	description = "Обычная канцелярская скрепка из хорошей, тугой проволоки.";
}

obj {
	nam = 'tablebox';
	-"ящик";
	found_in = 'grandroom';
	before_Transfer = function(s)
		if s:has'open' then
			mp:xaction("Close", s)
		else
			mp:xaction("Open", s)
		end
	end;
	before_Pull = function(s) mp:xaction("Open", s) end;
	before_Push = function(s) mp:xaction("Close", s) end;
	after_Open = function(s) p [[Ты выдвинул ящик стола.]]; mp:content(s) end;
	after_Close = [[Ты задвинул ящик стола.]];
	when_open = [[Ящик стола выдвинут.]];
	when_closed = [[Ящик стола задвинут.]];
}:attr'scenery,openable,container';

room {
	-"комната дедушки,комната";
	nam = 'grandroom';
	Smell = [[Ты чувствуешь запах пирожков.]];
	Listen = [[Ты слышишь чириканье воробьёв, доносящееся из окна.]];
	title = 'Комната дедушки';
	dsc = [[Дедушки в комнате нет. Наверное, он ушёл на рыбалку.]];
	out_to = 'corridor';
	['before_Jump,JumpOver'] = function(s)
		if pl:inside'ironbed' then
			p [[Ты подпрыгиваешь на пружинной кровати. Раз, два, три! Ух, как здорово! К самому потолку!]];
		else
			p [[На дедушкиной пружинной кровати очень здорово прыгать. Но сначала, нужно на неё залезть.]]
		end
	end;
}: with {
	Path {
		-"коридор";
		walk_to = 'corridor';
	};
	'window';
}

Verb {
	"сходи/ть";
	"в {noun}/вн,enterable : Walk";
}

-- идеи:
-- пирожок толстому мальчику за фонарик.
-- ключ -> сарай -> лук из удочки бамбука.
-- стрела -- рейка + целофан + огонь.
-- скрепка -> отмычка
-- в туалете - флакон от шампуня.
-- компас -> просто дают
-- спички нужны
-- враги: паук(огонь), крыса(лук)

declare 'make_p' (function()
		return obj {
			-"пирожок";
		}:attr'edible'
		 end)
obj {
	-"бабушка";
	found_in = 'kitchenroom';
	description = [[Бабушка делает пирожки. Это их запах заполняет весь дом.]];
	before_Kiss = [[-- Осторожно, внучик, мука!]];
	dsc = [[Ты видишь как бабушка делает пирожки.]];
	['before_Talk,Say,Ask,Tell'] = function(s)
		p [[-- Держи пирожок!]];
		take(new (make_p))
	end;
}:attr'animated'

obj {
	-"стол";
	found_in = 'kitchenroom'
}:attr'scenery,supporter':with {
	obj {
		-"пирожки|пирожок";
		description = "Среди них наверняка есть с яйцом и луком -- твои любимые!";
		before_Smell = [[Как пахнет!]];
		['before_Touch,Take,Push,Pull,Transfer,Taste'] = [[Лучше попросить у бабушки.]];
	}:attr'edible';
}

room {
	-"кухня";
	nam = 'kitchenroom';
	Smell = [[Ты чувствуешь, как восхитительно пахнут пирожки.]];
	title = 'Кухня';
	dsc = function(s)
		if s:once() then
			p [[-- Доброе утро, внучик! -- приветствует тебя бабушка. Ты видишь перед ней на столе ряды свежеиспечённых пирожков.]]
			pn "^"
		end
		p [[На кухне пахнет свежими пирожками. Ты можешь пройти в коридор, туалет или выйти на улицу.]];
	end;
	out_to = 'street';
}:with {
	Path {
		-"коридор";
		walk_to = 'corridor';
	};
	Path {
		-"улица";
		walk_to = 'street';
		desc = [[Ты можешь пойти на улицу.]];
	};
	obj {
		-"туалет";
		['before_Walk,Enter'] = function(s)
			if s:once() then
				p [[Ты воспользовался туалетом.]]
			else
				p [[Ты уже был в туалете.]]
			end
		end;
		before_Default = [[Ты можешь сходить в туалет, если хочешь.]];
	}:attr'scenery';
	'window';
}

obj {
	-"сарай";
	dsc = [[Напротив дома расположен сарай.]];
	description = function(s)
		p [[В сарае дедушка хранит разный интересный хлам.]]
		if s:hasnt'open' then
			p [[Сейчас сарай закрыт.]]
		else
			p [[Сейчас сарай открыт.]]
		end
	end;
	with_key = 'key';
	after_Unlock = function(s) s:attr'open' p [[Ты открыл сарай с помощью ключа.]] end;
	after_Lock = function(s) s:attr'~open' p [[Ты запер сарай на ключ.]] end;
	before_Unlock = function(s, w)
		if w ^ 'wire' then
			p [[У дедушки есть ключ. Нет смысла взламывать сарай.]];
			return
		end
		return false
	end;
	found_in = 'street';
	['before_Enter,Climb'] = function(s)
		walk 'warehouse'
	end;
}:attr 'static,enterable,openable,lockable,locked';

obj {
	-"цветы|клумбы";
	found_in = 'street';
	description = [[Ты не разбираешься в цветах, но они очень красивые и хорошо пахнут.]];
	before_Take = [[Зачем зря рвать цветы?]];
}:attr'scenery';

room {
	-"улица";
	nam = 'street';
	title = "На улице";
	Smell = [[Запах цветов кружит тебе голову.]];
	dsc = [[Ты стоишь на улице возле своего дома, утопающего в цветах. Отсюда ты можешь пойти на футбольное поле
или во двор.]];
	in_to = 'house';
}: with {
	obj {
		nam = 'house';
		description = [[Одноэтажный кирпичный домик окрашенный в белый цвет. Он кажется тебе самым уютным домом на свете.]];
		-"дом|дверь";
		['before_Enter,Climb'] = function()
			walk 'kitchenroom'
		end;
	}:attr'scenery';
	Path {
		-"футбольное поле|поле";
		walk_to = 'field';
		desc = [[Ты можешь пойти на футбольное поле.]];
	};
}

function mp:CutSaw(w, wh)
	if not wh and not have'saw' then
		p [[Тебе не чем пилить.]]
		return
	end
	if not wh then wh = _'saw' end
	if not have(wh) then
		p ([[Сначала нужно взять ]], wh:noun'вн', ".")
		return
	end
	if wh ~= _'saw' then
		p ([[Пилить ]], wh:noun 'тв', " не получится.")
		return
	end
	if w == wh or w == me() then
		p [[Интересно, как это получится?]];
		return
	end
	if mp:check_live(w) then
		return
	end
	p ([[У тебя не получилось запилить ]], w:noun'вн', " ", wh:noun'тв',".");
end

Verb {
	"[|рас|вы|за|от]пили/ть,[|рас|вы|за|от]пилю";
	"{noun}/вн : CutSaw";
	"{noun}/вн {noun}/тв,held : CutSaw";
}

obj {
	-"удочка";
	nam = 'bow';
	description = [[Старая удочка из гибкого бамбука. Здорово гнётся!]];
	found_in = 'junk';
}:disable();

obj {
	-"лобзик";
	nam = 'saw';
	description = [[Лобзик для выпиливания по дереву. Ещё почти не ржавый!]];
	found_in = 'junk';
}:disable();

obj {
	-"хлам";
	nam = 'junk';
	before_Take = [[Ты можешь поискать в хламе что-нибудь интересное.]];
	description = function(s)
		if not disabled'saw' and _'saw':inside(s) or
		not disabled'bow' and _'bow':inside(s) then
			mp:content(s)
		else
			p [[Тут, наверное, много всего интересного, если поискать.]];
		end
	end;
	['before_Search,LookUnder'] = function(s)
		if disabled'bow' then
			p [[Ты покопался в хламе и нашёл старую удочку.]];
			enable'bow'
		elseif disabled'saw' then
			p [[Ты покопался в хламе и нашёл лобзик.]];
			enable'saw'
		else
			p [[Вроде больше ничего интересного не находится.]];
		end
	end;
	found_in = 'warehouse';
}:attr'scenery,container,open':dict {
	["хлам/пр,2"] = "хламе";
};

room {
	-"сарай";
	title = "сарай";
	nam = 'warehouse';
	dsc = [[Сарай завален разным интересным хламом. Ты можешь выйти из сарая на улицу.]];
	Smell = [[Пахнет резиной и бензином.]];
	out_to = 'street';
}: with {
	Path {
		-"улица";
		walk_to = 'street';
		descr = [[Ты можешь пойти на улицу.]];
	};
}

room {
	-"поле";
	title = "футбольное поле";
}: with {
	Path {
		-"дом";
		walk_to = 'street';
		descr = [[Ты можешь пойти к своему дому.]];
	}
}
