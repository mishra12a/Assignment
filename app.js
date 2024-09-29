const express = require('express');
const bodyParser = require('body-parser');
const authRoutes = require('./routes/authroutes');
const productRoutes = require('./routes/productroute');
const cors=require('cors');

const app = express();
app.use(cors());
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

app.use('/api', authRoutes);
app.use('/api', productRoutes);

const PORT = 3000;
app.listen(PORT, '0.0.0.0', () => {
    console.log(`Server is running on port ${PORT}`);
  });