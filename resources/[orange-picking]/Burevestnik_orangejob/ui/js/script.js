/* 
-- ██████╗░██╗░░░██╗██████╗░███████╗██╗░░░██╗███████╗░██████╗████████╗███╗░░██╗██╗██╗░░██╗
-- ██╔══██╗██║░░░██║██╔══██╗██╔════╝██║░░░██║██╔════╝██╔════╝╚══██╔══╝████╗░██║██║██║░██╔╝
-- ██████╦╝██║░░░██║██████╔╝█████╗░░╚██╗░██╔╝█████╗░░╚█████╗░░░░██║░░░██╔██╗██║██║█████═╝░
-- ██╔══██╗██║░░░██║██╔══██╗██╔══╝░░░╚████╔╝░██╔══╝░░░╚═══██╗░░░██║░░░██║╚████║██║██╔═██╗░
-- ██████╦╝╚██████╔╝██║░░██║███████╗░░╚██╔╝░░███████╗██████╔╝░░░██║░░░██║░╚███║██║██║░╚██╗
-- ╚═════╝░░╚═════╝░╚═╝░░╚═╝╚══════╝░░░╚═╝░░░╚══════╝╚═════╝░░░░╚═╝░░░╚═╝░░╚══╝╚═╝╚═╝░░╚═╝*/

function init() {
	document.body.style.display = 'block'
	let zone = document.getElementById('zone');
	let spawn = document.getElementById('spawnZone');
	const maxCount = Math.floor(Math.random() * (10 - 8)) + 8
	document.getElementById('count'). innerText = `0`
	document.getElementById('maxCount').innerText = String(maxCount)
	for(let i = 0; i < maxCount; i++) {
		let orange = document.createElement('div')
		orange.id = `orange-${i}`
		orange.classList.add('orange')
		document.body.appendChild(orange);
		const position = getOrangePosition(spawn.offsetHeight / 2 - 600, 450, spawn.offsetWidth / 2 - 800, 850)
		orange.style.position = 'absolute';
		orange.style.zIndex = 1000;
		orange.style.left = position.x
		orange.style.top = position.y

		orange.onmousedown = function(e) {
			if (orange.getAttribute("data-inzone") === "true") {
				return
			}

			function moveAt(e) {
				const x = e.pageX - orange.offsetWidth / 2
				const y = e.pageY - orange.offsetHeight / 2
				if (x > 0 && x < spawn.offsetWidth - orange.offsetWidth) {
					orange.style.left = x + 'px';
				}
				if(y > 0 && y < spawn.offsetHeight - orange.offsetHeight) {
					orange.style.top = y + 'px';
				}
			}

			document.onmousemove = function(e) {
				moveAt(e);
			}

			function stop() {
				document.onmousemove = null;
				orange.onmouseup = null;

				if (orange.offsetTop > zone.offsetTop && orange.offsetLeft > zone.offsetLeft && orange.offsetLeft < zone.offsetLeft + zone.offsetWidth) {
					const count = +zone.getAttribute("data-count") + 1 + ''
					zone.setAttribute("data-count", count)
					document.getElementById('count'). innerText = count
					orange.setAttribute("data-inzone", "true")
					orange.style.display = 'none'
					if(+count === maxCount) {
						$.post('https://Burevestnik_orangejob/bur_done_orangejob', JSON.stringify({orange: maxCount}));
						close()
					}
				}
			}

			orange.onmouseup = stop

			orange.ondragstart = function() {
				return false;
			};
		}
	}
}

function getOrangePosition(top, height, left, width) {
	return {
		x: Math.floor(Math.random() * width) + left,
		y: Math.floor(Math.random() * height) + top,
	}
}

window.addEventListener('message', function(event) {
	var item = event.data;
	if (item.showUI) {
		$('html').show();
		init();
	} else {
		$('html').hide();
	}
});

function close() {
	$.post('https://Burevestnik_orangejob/bur_exit_orangejob', JSON.stringify({}));
	document.location.reload();
	return;
}

document.onkeyup = function (data){
	if (data.which == 27) {
		close()
	}
};