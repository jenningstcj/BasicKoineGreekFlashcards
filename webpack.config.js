module.exports = {
    entry: "./src/main.js",
    output: {
        path: "./build/",
        filename: "bundle.js",
        publicPath: './build/'
    },
    module: {
        loaders: [
                    {
                      test: /\.jsx?$/,
                      exclude: /(node_modules|bower_components)/,
                      loader: 'babel',
                      query: {
                        presets: ['react', 'es2015']
                      }
                    },
                    {
                      test: /\.(jpe?g|png|gif|svg)$/i,
                      loaders: [
                        'url?limit=8192',
                        'img'
                        ]
                    },
                    {
                      test: /\.less$/,
                      loader: "style!css!less"
                    },
        ]
    }
};
