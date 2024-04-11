import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class PollHomePage extends StatelessWidget {
  const PollHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
     
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Poll Results',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.0),
            Expanded(
              child: PollResultsChart(),
            ),
            SizedBox(height: 20.0),
            Text(
              'Articles',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.0),
            Expanded(
              child: ArticleLinks(),
            ),
          ],
        ),
      ),
    );
  }
}

class PollResultsChart extends StatelessWidget {
  const PollResultsChart({super.key});

  @override
  Widget build(BuildContext context) {
    // Định nghĩa dữ liệu cho biểu đồ (đây là dữ liệu giả định)
    var data = [
      ClicksPerArticle('Article 1', 35),
      ClicksPerArticle('Article 2', 55),
      ClicksPerArticle('Article 3', 20),
      ClicksPerArticle('Article 4', 45),
    ];

    // Tạo series cho biểu đồ
    var series = [
      charts.Series(
        id: 'Clicks',
        data: data,
        domainFn: (ClicksPerArticle clicks, _) => clicks.article,
        measureFn: (ClicksPerArticle clicks, _) => clicks.clicks,
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
      )
    ];

    // Tạo biểu đồ cột
    return charts.BarChart(
      series,
      animate: true,
    );
  }
}

class ArticleLinks extends StatelessWidget {
  const ArticleLinks({super.key});

  @override
  Widget build(BuildContext context) {
    // Thay thế dữ liệu này bằng dữ liệu thực tế của bạn
    // Mỗi liên kết sẽ dẫn đến một bài viết cụ thể
    var articles = [
      'Article 1',
      'Article 2',
      'Article 3',
      'Article 4',
    ];

    // Tạo danh sách các liên kết đến các bài báo
    return ListView.builder(
      itemCount: articles.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(articles[index]),
          onTap: () {
            // Điều hướng đến trang chi tiết của bài viết khi người dùng nhấn vào liên kết
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      ArticleDetailPage(article: articles[index])),
            );
          },
        );
      },
    );
  }
}

class ClicksPerArticle {
  final String article;
  final int clicks;

  ClicksPerArticle(this.article, this.clicks);
}

class ArticleDetailPage extends StatelessWidget {
  final String article;

  const ArticleDetailPage({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(article),
      ),
      body: Center(
        child: Text('Detail of $article'),
      ),
    );
  }
}


