//Escala linear

var config_br = {
    type: 'line',
    data: {
        labels: dias,
        datasets: [{
            label: 'Total de casos',
            fill: false,
            backgroundColor: 'rgba(189,0,38,0.4)',
            borderColor: 'rgba(189,0,38,0.7)',
            data: casos,
        },{
            label: 'Total de mortes',
            fill: false,
            backgroundColor: 'rgba(33,102,172,0.4)',
            borderColor: 'rgba(33,102,172,0.7)',
            data: mortes,
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
            text: 'Escala Linear'
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
                ticks: {
                    beginAtZero:true
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

var ctx_br = document.getElementById('Chart_BR').getContext('2d');
Chart_br = new Chart(ctx_br, config_br);