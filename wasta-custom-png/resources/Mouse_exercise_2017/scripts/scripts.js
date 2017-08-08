// "goto" functions are for the double click practice
function goto21() {
    location.href = "page21.html"
}

function goto22() {
    location.href = "page22.html"
}

function goto23() {
    location.href = "page23.html"
}

function goto24() {
    location.href = "page24.html"
}

function goto25() {
    location.href = "page25.html"
}

function goto26() {
    location.href = "page26.html"
}

function goto27() {
    location.href = "page27.html"
}

// Page 28
function togglelink(idnum) {
	var e = document.getElementById(idnum);
	if (e.style.display == 'block') 
		e.style.display = 'none';
	else
		e.style.display = 'block';
}

// Page 30
function formHandler(form) {
    var URL = form.site.options[form.site.selectedIndex].value;
    window.location.href = URL;
}

// Page 32, 33, 34, 35
function surfto(form) {
    var myindex=form.dest.selectedIndex
    location=form.dest.options[myindex].value;
}

// Page 35
function drawAlert () {
    alert ("When windows pop up. Read their message and click OK.");
}

//Page 36
function checkTextField(fn, ln) {
    if ((fn.value !== '') && (ln.value !== '')) {
        linktonext.style.display = 'block';
    }
}

//Page 38
function checkTextField2(n1, n2, n3, n4) {
    if ((n1.value !== '') && (n2.value !== '') && (n3.value !== '') && (n4.value !== '')) {
        linktonext.style.display = 'block';
    }
}

function showAnswers() {
    answers.style.display = 'block';
}

function allowDrop(ev) {
    ev.preventDefault();
}

function drag(ev) {
    ev.dataTransfer.setData("text", ev.target.id);
}

function drop(ev) {
    ev.preventDefault();
    var data = ev.dataTransfer.getData("text");
    ev.target.appendChild(document.getElementById(data));
    linktonext.style.display = 'block';
}