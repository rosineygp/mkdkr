pipeline {
  agent {
    node {
      label 'any'
    }
  }

  stages("mkdkr_exporter") {
    stage("lint") {
      parallel {
        stage("lint commit") {
          steps {
            sh "make lint.commit"
          }
        }
        stage("lint shellcheck") {
          steps {
            sh "make lint.shellcheck"
          }
        }
      }
    }
  
    stage("test unit") {
      steps {
        sh "make test.unit"
      }
    }
    stage("examples") {
      parallel {
        stage("examples simple") {
          steps {
            sh "make examples.simple"
          }
        }
        stage("examples service") {
          steps {
            sh "make examples.service"
          }
        }
        stage("examples dind") {
          steps {
            sh "make examples.dind"
          }
        }
        stage("examples escapes") {
          steps {
            sh "make examples.escapes"
          }
        }
        stage("examples stdout") {
          steps {
            sh "make examples.stdout"
          }
        }
        stage("examples shell") {
          steps {
            sh "make examples.shell"
          }
        }
        stage("examples pipeline") {
          steps {
            sh "make examples.pipeline"
          }
        }
      }
    }
  
  }
}
