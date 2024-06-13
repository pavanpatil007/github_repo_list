import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../bloc/repository_bloc.dart';
import '../bloc/repository_event.dart';
import '../bloc/repository_state.dart';


class RepositoryListScreen extends StatelessWidget {
  const RepositoryListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black.withAlpha(120),
        title: Text('GitHub Repositories',style: GoogleFonts.poppins(fontWeight: FontWeight.w500,fontSize: 18,color: Colors.white),),
      ),
      body: BlocConsumer<RepositoryBloc, RepositoryState>(
        listener: (context, state) {
          if (state is RepositoryLoadFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Failed to load repositories')),
            );
          }
        },
        builder: (context, state) {
          print("Current state: $state"); // Log the current state
          if (state is RepositoryLoadInProgress) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is RepositoryLoadSuccess) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<RepositoryBloc>().add(RefreshRepositories());
              },
              child: ListView.builder(
                itemCount: state.repositories.length,
                itemBuilder: (context, index) {
                  final repo = state.repositories[index];
                  return Card(
                    elevation: 3,
                    surfaceTintColor: Colors.white,
                    child: ListTile(
                      title: Text(repo.name,style: GoogleFonts.lato(fontWeight: FontWeight.w500,fontSize: 18),),
                      subtitle: Text(repo.description??"NA",style: GoogleFonts.lato(),),
                      trailing: Text('${repo.stargazers_count} ⭐',style: GoogleFonts.lato(fontSize: 14),),
                      onTap: () => _launchURL(repo.html_url),
                    ),
                  );
                },
              ),
            );
          } else {
            return const Center(child: Text('Failed to load repositories'));
          }
        },
      ),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
