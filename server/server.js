const express = require('express'),
    app = express();


app.get('/people', (req, res) => {
    res.status(200).json([
        { name: "Carlos" },
        { name: "Peter" },
        { name: "Loes" },
        { name: "Sabrina" }
    ])
})

app.get('/person', (req, res) => {
    res.status(200).json({ name: "Carlos" });
})

app.listen(4445);