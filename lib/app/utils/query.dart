import 'package:graphql_flutter/graphql_flutter.dart';

getAllCharachters() => gql(r"""
  query GetCharachters ($page:Int){
    characters (page:$page) {
      info {
        next
      }
      results {
        id
        status
        species
        gender
        image
        type
        name
        location{
          name
        }
      }
    }
  }
""");
getCharacterDetail() => gql(r"""
  query ($id: ID!) {
  character(id: $id) {
    name
    id
    episode {
      name
      episode
    }
    status
    species
    image
    gender
    origin {
      name
    }
    location {
      name
    }
  }
}

""");
