var config_totalcases = {
    type: 'line',
    data: {
        labels: dias,
        datasets: [{
            label: 'USA',
            fill: false,
            backgroundColor: 'rgba(5, 80, 156,0.4)',//#05509c
            borderColor: 'rgba(5, 80, 156,0.7)',
            data: US_totalcases,
        },{
            label: 'Brazil',
            fill: false,
            backgroundColor: 'rgba(35, 120, 46,0.4)',//#23782e
            borderColor: 'rgba(35, 120, 46)',
            data: Brazil_totalcases,
        },{
            label: 'UK',
            fill: false,
            backgroundColor: 'rgba(191, 6, 12,0.4)',//#bf060c
            borderColor: 'rgba(191, 6, 12,0.7)',
            data: UK_totalcases,
        },{
            label: 'Germany',
            fill: false,
            backgroundColor: 'rgba(0, 0, 0,0.4)',//#000000
            borderColor: 'rgba(0, 0, 0,0.7)',
            data: Germany_totalcases,
        },{
            label: 'Peru',
            fill: false,
            backgroundColor: 'rgba(83, 15, 171,0.4)',//#530fab
            borderColor: 'rgba(83, 15, 171,0.7)',
            data: Peru_totalcases,
        },{
            label: 'Italy',
            fill: false,
            backgroundColor: 'rgba(176, 14, 144,0.4)',//#b00e90
            borderColor: 'rgba(176, 14, 144,0.7)',
            data: Italy_totalcases,
        },{
            label: 'India',
            fill: false,
            backgroundColor: 'rgba(91, 235, 59,0.4)',//#5beb3b
            borderColor: 'rgba(91, 235, 59,0.7)',
            data: India_totalcases,
        },{
            label: 'Spain',
            fill: false,
            backgroundColor: 'rgba(59, 214, 235,0.4)',//#3bd6eb
            borderColor: 'rgba(59, 214, 235,0.7)',
            data: Spain_totalcases,
        },{
            label: 'Russia',
            fill: false,
            backgroundColor: 'rgba(217, 112, 26,0.4)',//#d9701a
            borderColor: 'rgba(217, 112, 26,0.7)',
            data: Russia_totalcases,
        },{
            label: 'Turkey',
            fill: false,
            backgroundColor: 'rgba(240, 201, 60,0.4)',//#f0c93c
            borderColor: 'rgba(240, 201, 60,0.7)',
            data: Turkey_totalcases,
        },{
            label: 'Iran',
            fill: false,
            backgroundColor: 'rgba(250, 52, 154,0.4)',//#fa349a
            borderColor: 'rgba(250, 52, 154,0.7)',
            data: Iran_totalcases,
        },{
            label: 'Chile',
            fill: false,
            backgroundColor: 'rgba(130, 74, 60,0.4)',//#824a3c
            borderColor: 'rgba(130, 74, 60,0.7)',
            data: Chile_totalcases,
        },{
            label: 'China',
            fill: false,
            backgroundColor: 'rgba(140, 149, 156,0.4)',//#8c959c
            borderColor: 'rgba(140, 149, 156,0.7)',
            data: China_totalcases,
        }]
    },
    options: {
        responsive: true,
        legend: {
            display: false,
        },
        title: {
            display: true,
            text: ''
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
                    labelString: 'Total cases'
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

var ctx_totalcases = document.getElementById('Chart_totalcases').getContext('2d');
Chart_totalcases = new Chart(ctx_totalcases, config_totalcases);