--$Name:Летний день$
--$Author:Пётр Косых$
--$Info:Игра для Инстедоз-6$

require "fmt"
fmt.dash = true
fmt.quotes = true

loadmod 'mp-ru'

pl.description = [[Тебя зовут Серёжа и тебе 9 лет.]];

Verb {
	"просыпаться,просыпайся";
	"Wake";
}

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
	obj {
		-"гостиная";
		['before_Walk,Enter'] = function(s) walk "livingroom"; end;
		before_Default = [[Ты можешь пойти в гостиную.]];
	}:attr'scenery';
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
	Listen = [[Ты слышишь звуки летнего утра.]];
	dsc = [[Гостиная кажется тебе огромной. Ты можешь пройти в спальню или коридор.]];
}: with {
	obj {
		-"спальня,спальная";
		['before_Walk,Enter'] = function(s) walk "bedroom"; end;
		before_Default = [[Ты можешь пойти в спальню.]];
	}:attr'scenery';
	obj {
		-"коридор";
		['before_Walk,Enter'] = function(s) walk "corridor"; end;
		before_Default = [[Ты можешь пойти в коридор.]];
	}:attr'scenery';
	'window';
}

room {
	-"коридор";
	title = 'коридор';
	nam = 'corridor';
	Smell = [[Ты чувствуешь запах пирожков из кухни.]];
	dsc = [[Из узкого коридора можно попасть в гостиную, кухню и комнату дедушки.]];
}: with {
	obj {
		-"гостиная";
		['before_Walk,Enter'] = function(s) walk "livingroom"; end;
		before_Default = [[Ты можешь пойти в гостиную.]];
	}:attr'scenery';
	obj {
		-"комната дедушки,комната";
		['before_Walk,Enter'] = function(s) walk "grandroom"; end;
		before_Default = [[Ты можешь пойти в комнату дедушки.]];
	}:attr'scenery';
	obj {
		-"кухня";
		['before_Walk,Enter'] = function(s) walk "kitchenroom"; end;
		before_Default = [[Ты можешь пойти на кухню.]];
	}:attr'scenery';
}

Furniture {
	nam = 'ironbed';
	-"железная кровать,кровать";
	found_in = 'grandroom';
	description = [[Железная кровать дедушки хорошо пружинит. На ней очень здорово прыгать.]];
}:attr 'supporter,enterable';

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
	"[вы|за]двин/уть",
	"{noun}/вн,openable : Push"
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
	after_Open = [[Ты выдвинул ящик стола.]];
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
	obj {
		-"коридор";
		['before_Walk,Enter'] = function(s) walk "corridor"; end;
		before_Default = [[Ты можешь пойти в коридор.]];
	}:attr'scenery';
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
	obj {
		-"коридор";
		['before_Walk,Enter'] = function(s) walk "corridor"; end;
		before_Default = [[Ты можешь пойти в коридор.]];
	}:attr'scenery';
	obj {
		-"улица";
		['before_Walk,Enter'] = function(s) walk "street"; end;
		before_Default = [[Ты можешь пойти на улицу.]];
	}:attr'scenery';
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

room {
	-"улица";
	nam = 'street';
	title = "На улице";
	dsc = [[Ты стоишь на улице возле своего дома. Отсюда ты можешь пойти на футбольное поле
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
}
