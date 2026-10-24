<?php
/**
 * Fail when line coverage in a Clover report is below a threshold.
 * Usage: php docker/check-coverage.php build/clover.xml 80
 */

$report = $argv[1] ?? 'build/clover.xml';
$min    = (float) ( $argv[2] ?? 80 );

$xml = simplexml_load_file( $report );
if ( false === $xml ) {
	fwrite( STDERR, "Cannot read $report\n" );
	exit( 2 );
}

$metrics = $xml->project->metrics;
$total   = (int) $metrics['statements'];
$covered = (int) $metrics['coveredstatements'];
$percent = $total > 0 ? 100 * $covered / $total : 0.0;

printf( "Line coverage: %.2f%% (%d/%d), required %.0f%%\n", $percent, $covered, $total, $min );
exit( $percent >= $min ? 0 : 1 );
