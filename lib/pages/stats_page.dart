import 'package:flutter/material.dart';
import 'package:kino_byte/services/databaseService.dart';
import 'package:kino_byte/helpers/barchart.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  late Future<Map<String, dynamic>>? _statsData;
  bool _isFetching = false;
  final DatabaseService _databaseService = DatabaseService.instance;

  @override
  void initState() {
    super.initState();
    _statsData = _databaseService.getStats;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (ModalRoute.of(context)!.isCurrent && !_isFetching) {
      _fetchData();
    }
  }

  Future<void> _fetchData() async {
    setState(() {
      _isFetching = true;
      _statsData = _databaseService.getStats;
    });

    await _statsData;

    setState(() {
      _isFetching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _statsData,
      builder:(context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting){
          return  const Center(child: CircularProgressIndicator());
        } 
        else if (snapshot.hasData) {
          dynamic movieStats = snapshot.data;
          return CustomScrollView(
            slivers: [
              SliverList(
                delegate: SliverChildListDelegate([
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    child: Text('Overview',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 5,
                      )
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: const Color.fromARGB(255, 23, 23, 70),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('movies watched',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                            )
                          ),
                          Text('${movieStats['number_movies']}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 40,
                            )
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: const Color.fromARGB(255, 23, 23, 70),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('unique movies',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                            )
                          ),
                          Text('${movieStats['number_unique_movies']}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 40,
                            )
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: const Color.fromARGB(255, 23, 23, 70),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('total time',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                            )
                          ),
                          Text('${movieStats['total_runtime']~/1440}d ${'${(movieStats['total_runtime']%1440)~/60}'.padLeft(2,'0')}h ${'${movieStats['total_runtime']%60}'.padLeft(2,'0')}m',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 40,
                            )
                          ),
                        ],
                      ),
                    ),
                  ), 
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text('Most Watched',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 5,
                      )
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 230,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: const Color.fromARGB(255, 23, 23, 70),
                        // color: Colors.black,
                      ),
                      child: ListView.builder(
                        itemCount: movieStats['top_movies'].length,
                        shrinkWrap: true,
                        // physics: const NeverScrollableScrollPhysics(),
                        // itemCount: 10,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: const Color.fromARGB(255, 23, 23, 70),
                              ),
                              child: ListTile(
                                textColor: Colors.white,
                                leading: Text('${index + 1}',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  )
                                ),
                                title: Text('${movieStats['top_movies'][index]['movie_title']} (${movieStats['top_movies'][index]['year']})',),
                                subtitle: Text('Watched ${movieStats['top_movies'][index]['times_watched']} times',
                                  style: const TextStyle(
                                    fontSize: 12,
                                  )),
                              ),
                            ),
                          );
                        }
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text('Progress',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 5,
                      )
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color.fromARGB(255, 23, 23, 70),
                      // color: Colors.black,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: BarChartStats(chartData: movieStats['movies_per_year'],),
                    )
                  ), 
                ])
              ),
            ],
          );
        }
        else {
          return const Center(
            child: Text('THERE WAS SOMETHING WRONG',
              style: TextStyle(color: Colors.red)),
          );
        }
      },
    );
  }
}