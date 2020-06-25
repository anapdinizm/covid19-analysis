// Escala logaritmica

var config_br_log = {
    type: 'line',
    data: {
        labels: dias_log,
        datasets: [{
            label: 'Total de casos',
            fill: false,
            backgroundColor: 'rgba(33,102,172,0.4)',
            borderColor: 'rgba(33,102,172,0.7)',
            data: casos_log,
        },{
            label: 'Total de mortes',
            fill: false,
            backgroundColor: 'rgba(189,0,38,0.4)',
            borderColor: 'rgba(189,0,38,0.7)',
            data: mortes_log,
        }]
    },
    options: {
        responsive: true,
        legend: {
          labels : {
              boxWidth: 2
          }
        },
        title: {
            display: true,
            text: 'Escala Logarítmica'
        },
        tooltips: {
            mode: 'index',
            intersect: false,
        },
        hover: {
            mode: 'nearest',
            intersect: true
        },
        scales: {
            xAxes: [{
                display: true,
                scaleLabel: {
                    display: true,
                    labelString: 'Data'
                }
            }],
            yAxes: [{
                display: true,
                scaleLabel: {
                    display: true,
                    labelString: 'Número de pessoas'
                },
                type: 'logarithmic',
                position: 'left',
                ticks: {
                    min: 1, //minimum tick
                    max: 1000000, //maximum tick
                    callback: function (value, index, values) {
                        return Number(value.toString());//pass tick values as a string into Number function
                    }
                },
                afterBuildTicks: function (chartObj) { //Build ticks labelling as per your need
                    chartObj.ticks = [];
                    chartObj.ticks.push(1);
                    chartObj.ticks.push(10);
                    chartObj.ticks.push(100);
                    chartObj.ticks.push(1000);
                    chartObj.ticks.push(10000);
                    chartObj.ticks.push(100000);
                    chartObj.ticks.push(1000000);
                }
            }]
        },
        annotation: {
            annotations: []
        },
        elements: { 
            point: { 
              radius: 0,
              hitRadius: 10, 
              hoverRadius: 10 } 
        }
    }
};

var ctx_br_log = document.getElementById('Chart_BR_log').getContext('2d');
Chart_br_log = new Chart(ctx_br_log, config_br_log);
