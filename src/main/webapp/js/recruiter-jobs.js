(function () {
    const form = document.getElementById('job-form');
    if (!form) return;

    const locationInput = document.getElementById('location');
    const titleInput = document.getElementById('title');
    const jobTypeInput = document.getElementById('job_type');
    const statusInput = document.getElementById('status');
    const skillsInput = document.getElementById('skills');
    const skillEntry = document.getElementById('skill-entry');
    const skillsEditor = document.getElementById('skills-editor');
    const payDisplay = document.getElementById('pay_display');
    const payInput = document.getElementById('pay');
    const qualificationsInput = document.getElementById('qualifications');
    const descriptionInput = document.getElementById('description');
    const deadlineInput = document.getElementById('deadline');
    const deadlineDisplay = document.getElementById('deadline_display');
    const deadlineToggle = document.getElementById('deadline-toggle');
    const deadlineCalendar = document.getElementById('deadline-calendar');
    const datePicker = document.getElementById('date-picker');
    const feedback = document.getElementById('form-feedback');
    let skills = [];

    function setFeedback(elementId, message) {
        const element = document.getElementById(elementId);
        if (element) element.textContent = message;
    }

    function markInvalid(element, invalid) {
        if (element) element.classList.toggle('input-invalid', invalid);
    }

    function validateLocation() {
        const valid = locationInput.value !== '';
        setFeedback('location-feedback', valid ? '' : 'Choose a location.');
        markInvalid(locationInput, !valid);
        return valid;
    }

    function validateTitle() {
        const valid = titleInput.value.trim() !== '';
        markInvalid(titleInput, !valid);
        return valid;
    }

    function validateRequiredInput(input) {
        const valid = !input || input.value.trim() !== '';
        markInvalid(input, !valid);
        return valid;
    }

    function renderSkills() {
        skillsEditor.innerHTML = '';
        skills.forEach(function (skill, index) {
            const badge = document.createElement('span');
            badge.className = 'skill-badge';
            badge.textContent = skill;
            const remove = document.createElement('button');
            remove.type = 'button';
            remove.className = 'skill-remove';
            remove.setAttribute('aria-label', 'Remove ' + skill);
            remove.textContent = '×';
            remove.addEventListener('click', function () {
                skills.splice(index, 1);
                renderSkills();
                validateSkills();
                skillEntry.focus();
            });
            badge.appendChild(remove);
            skillsEditor.appendChild(badge);
        });
        skillsEditor.appendChild(skillEntry);
        skillsInput.value = skills.join(', ');
    }

    function addSkill(value) {
        const skill = value.trim().replace(/,$/, '').trim();
        if (!skill) return;
        if (skill.length > 100 || skills.some(function (item) { return item.toLowerCase() === skill.toLowerCase(); })) {
            setFeedback('skills-feedback', skill.length > 100 ? 'Each skill must be 100 characters or fewer.' : 'That skill is already added.');
            skillsInput.classList.add('input-invalid');
            return;
        }
        skills.push(skill);
        skillEntry.value = '';
        renderSkills();
        validateSkills();
        skillEntry.focus();
    }

    function validateSkills() {
        const valid = skills.length > 0 && skills.every(function (skill) { return skill.length <= 100; });
        setFeedback('skills-feedback', valid ? '' : 'Add at least one unique skill.');
        markInvalid(skillsInput, !valid);
        markInvalid(skillsEditor, !valid);
        return valid;
    }

    function validateQualifications() {
        const lines = qualificationsInput.value.split(/\r?\n/).map(function (line) { return line.trim(); }).filter(Boolean);
        const valid = lines.length > 0 && lines.every(function (line) { return line.length <= 500; });
        setFeedback('qualifications-feedback', valid ? '' : 'Enter one qualification per line; each must be 500 characters or fewer.');
        markInvalid(qualificationsInput, !valid);
        return valid;
    }

    function validateDeadline() {
        const valid = deadlineInput.value !== '' && deadlineInput.value >= deadlineInput.dataset.min;
        setFeedback('deadline-feedback', valid ? '' : 'Choose today or a future application deadline.');
        markInvalid(datePicker, !valid);
        return valid;
    }

    function isoDate(date) {
        return date.getFullYear() + '-' + String(date.getMonth() + 1).padStart(2, '0') + '-' + String(date.getDate()).padStart(2, '0');
    }

    function displayDate(iso) {
        if (!iso) return '';
        const parts = iso.split('-');
        return parts[1] + ' / ' + parts[2] + ' / ' + parts[0];
    }

    function parseTypedDate(value) {
        const text = value.trim();
        let match = text.match(/^(\d{1,2})\s*[\/-]\s*(\d{1,2})\s*[\/-]\s*(\d{4})$/);
        let year;
        let month;
        let day;
        if (match) {
            month = Number(match[1]);
            day = Number(match[2]);
            year = Number(match[3]);
        } else {
            match = text.match(/^(\d{4})-(\d{1,2})-(\d{1,2})$/);
            if (!match) return '';
            year = Number(match[1]);
            month = Number(match[2]);
            day = Number(match[3]);
        }
        const date = new Date(year, month - 1, day);
        if (date.getFullYear() !== year || date.getMonth() !== month - 1 || date.getDate() !== day) return '';
        return isoDate(date);
    }

    function formatDeadlineTyping(value) {
        const digits = value.replace(/\D/g, '').slice(0, 8);
        if (digits.length <= 2) return digits;
        if (digits.length <= 4) return digits.slice(0, 2) + ' / ' + digits.slice(2);
        return digits.slice(0, 2) + ' / ' + digits.slice(2, 4) + ' / ' + digits.slice(4);
    }

    function readTypedDeadline() {
        const typedValue = deadlineDisplay.value;
        if (!typedValue.trim()) {
            deadlineInput.value = '';
            setFeedback('deadline-feedback', '');
            markInvalid(datePicker, false);
            return;
        }
        const parsed = parseTypedDate(typedValue);
        if (!parsed) {
            deadlineInput.value = '';
            setFeedback('deadline-feedback', 'Enter a valid date as MM / DD / YYYY.');
            markInvalid(datePicker, true);
            return;
        }
        deadlineInput.value = parsed;
        calendarMonth = new Date(parsed + 'T00:00:00');
        deadlineDisplay.value = displayDate(parsed);
        validateDeadline();
    }

    let calendarMonth = deadlineInput.value
        ? new Date(deadlineInput.value + 'T00:00:00')
        : new Date();

    function renderCalendar() {
        const today = deadlineInput.dataset.min;
        const year = calendarMonth.getFullYear();
        const month = calendarMonth.getMonth();
        const firstDay = new Date(year, month, 1).getDay();
        const daysInMonth = new Date(year, month + 1, 0).getDate();
        let html = '<div class="calendar-header">'
            + '<button type="button" class="calendar-nav" data-calendar-action="previous" aria-label="Previous month">‹</button>'
            + '<strong>' + calendarMonth.toLocaleString('en-US', { month: 'long', year: 'numeric' }) + '</strong>'
            + '<button type="button" class="calendar-nav" data-calendar-action="next" aria-label="Next month">›</button>'
            + '</div><div class="calendar-weekdays">'
            + ['S', 'M', 'T', 'W', 'T', 'F', 'S'].map(function (day) { return '<span>' + day + '</span>'; }).join('')
            + '</div><div class="calendar-days">';

        for (let blank = 0; blank < firstDay; blank++) html += '<span class="calendar-empty"></span>';
        for (let day = 1; day <= daysInMonth; day++) {
            const date = new Date(year, month, day);
            const value = isoDate(date);
            const past = value < today;
            const weekend = date.getDay() === 0 || date.getDay() === 6;
            const selected = value === deadlineInput.value;
            html += '<button type="button" class="calendar-day'
                + (past ? ' is-past' : '') + (weekend ? ' is-weekend' : '') + (selected ? ' is-selected' : '')
                + '" data-date="' + value + '"' + (past ? ' disabled' : '') + '>' + day + '</button>';
        }
        html += '</div>';
        deadlineCalendar.innerHTML = html;
    }

    function openCalendar() {
        renderCalendar();
        deadlineCalendar.hidden = false;
    }

    deadlineDisplay.addEventListener('click', openCalendar);
    deadlineToggle.addEventListener('click', openCalendar);
    deadlineCalendar.addEventListener('click', function (event) {
        event.stopPropagation();
        const action = event.target.getAttribute('data-calendar-action');
        if (action === 'previous') calendarMonth.setMonth(calendarMonth.getMonth() - 1);
        if (action === 'next') calendarMonth.setMonth(calendarMonth.getMonth() + 1);
        if (action) {
            renderCalendar();
            return;
        }
        const selectedDate = event.target.getAttribute('data-date');
        if (selectedDate) {
            deadlineInput.value = selectedDate;
            deadlineDisplay.value = displayDate(selectedDate);
            deadlineCalendar.hidden = true;
            validateDeadline();
        }
    });
    document.addEventListener('click', function (event) {
        if (!datePicker.contains(event.target)) deadlineCalendar.hidden = true;
    });

    function formatPay(showCents) {
        const digits = payDisplay.value.replace(/[^0-9.]/g, '');
        const parts = digits.split('.');
        const whole = (parts[0] || '').replace(/^0+(?=\d)/, '');
        const decimals = parts.length > 1 ? parts[1].slice(0, 2) : '';
        const numeric = decimals ? whole + '.' + decimals : whole;
        payInput.value = numeric;
        if (numeric) {
            const amount = Number(numeric);
            payDisplay.value = Number.isFinite(amount) ? amount.toLocaleString('en-US', {minimumFractionDigits: showCents ? 2 : decimals.length, maximumFractionDigits: 2}) : '';
        }
    }

    function sanitizePayInput() {
        const original = payDisplay.value;
        const digits = original.replace(/[^0-9.]/g, '');
        const decimalIndex = digits.indexOf('.');
        const hasDecimal = decimalIndex >= 0;
        const whole = (hasDecimal ? digits.slice(0, decimalIndex) : digits).replace(/\./g, '');
        const decimals = hasDecimal ? digits.slice(decimalIndex + 1).replace(/\./g, '').slice(0, 2) : '';
        payDisplay.value = whole + (hasDecimal ? '.' + decimals : '');
        payInput.value = payDisplay.value;
    }

    const initialSkills = skillsEditor.getAttribute('data-initial-skills') || '';
    skills = initialSkills.split(',').map(function (skill) { return skill.trim(); }).filter(Boolean);
    renderSkills();
    deadlineDisplay.value = displayDate(deadlineInput.value);

    skillEntry.addEventListener('keydown', function (event) {
        if (event.key === 'Enter' || event.key === ',') {
            event.preventDefault();
            addSkill(skillEntry.value);
        }
        if (event.key === 'Backspace' && skillEntry.value === '' && skills.length > 0) {
            skills.pop();
            renderSkills();
            validateSkills();
            skillEntry.focus();
        }
    });
    skillEntry.addEventListener('blur', function () { if (skillEntry.value.trim()) addSkill(skillEntry.value); });
    skillsEditor.addEventListener('click', function () { skillEntry.focus(); });
    locationInput.addEventListener('change', validateLocation);
    titleInput.addEventListener('input', validateTitle);
    jobTypeInput.addEventListener('change', function () { validateRequiredInput(jobTypeInput); });
    if (statusInput) statusInput.addEventListener('change', function () { validateRequiredInput(statusInput); });
    descriptionInput.addEventListener('input', function () { validateRequiredInput(descriptionInput); });
    qualificationsInput.addEventListener('input', validateQualifications);
    deadlineDisplay.addEventListener('input', function () {
        const formattedValue = formatDeadlineTyping(deadlineDisplay.value);
        if (deadlineDisplay.value !== formattedValue) deadlineDisplay.value = formattedValue;
        const digits = formattedValue.replace(/\D/g, '');
        if (!digits) {
            deadlineInput.value = '';
            setFeedback('deadline-feedback', '');
            markInvalid(datePicker, false);
        } else if (digits.length < 8) {
            deadlineInput.value = '';
            setFeedback('deadline-feedback', '');
            markInvalid(datePicker, false);
        } else if (parseTypedDate(formattedValue)) {
            readTypedDeadline();
        } else {
            deadlineInput.value = '';
            setFeedback('deadline-feedback', 'Enter a valid date as MM / DD / YYYY.');
            markInvalid(datePicker, true);
        }
    });
    deadlineDisplay.addEventListener('blur', readTypedDeadline);
    payDisplay.addEventListener('input', sanitizePayInput);
    payDisplay.addEventListener('blur', function () { formatPay(true); });
    payDisplay.addEventListener('keydown', function (event) {
        if (event.ctrlKey || event.metaKey || event.altKey || ['Backspace', 'Delete', 'ArrowLeft', 'ArrowRight', 'Tab', 'Home', 'End'].indexOf(event.key) >= 0) return;
        if (!/[0-9.]/.test(event.key)) event.preventDefault();
    });
    payDisplay.addEventListener('keydown', function (event) {
        if (event.key === 'Enter') formatPay(true);
    });
    formatPay(true);

    form.addEventListener('submit', function (event) {
        formatPay(true);
        const validations = [
            validateTitle(),
            validateRequiredInput(jobTypeInput),
            validateRequiredInput(statusInput),
            validateLocation(),
            validateSkills(),
            validateQualifications(),
            validateRequiredInput(descriptionInput),
            validateDeadline()
        ];
        const valid = validations.every(function (fieldValid) { return fieldValid; });
        if (!form.checkValidity() || !valid) {
            event.preventDefault();
            feedback.textContent = 'Please correct the highlighted fields before submitting.';
            feedback.classList.add('visible');
        } else {
            feedback.textContent = '';
            feedback.classList.remove('visible');
        }
    });
}());
